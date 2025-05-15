import 'dart:async';
import 'dart:io';

import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/FirebaseConstants.dart';
import '../../_SharedData/AbstractDataRepository.dart';
import '../Domain/LoginEntityRequest.dart';
import '../Domain/RegisterRequest.dart';
import '../Domain/UserResponseDTO.dart';
import '../Domain/UserRole.dart';

class AuthRepository extends AbstractRepository {
  final Ref ref;

  AuthRepository(this.ref);

  User? get getCurrentUser => FirebaseAuth.instance.currentUser;

  String get getCurrentUserID => getCurrentUser!.uid;

  Future<UserRole?> signUp(RegisterRequest registerRequest) async {
    await firebaseAuth.signOut();
    try {
      var credentials = await firebaseAuth.createUserWithEmailAndPassword(
          email: registerRequest.email, password: registerRequest.password);
      final profileImageURL = await uploadPersonalImage(
          registerRequest.personalImageURL, credentials.user!.uid);
      if (credentials.user != null) {
        await credentials.user!.sendEmailVerification();

        await getCurrentCustomerDoc().set(registerRequest
            .copyWith(
                userId: firebaseAuth.currentUser!.uid,
                personalImageURL: profileImageURL)
            .toMap());
      }
      switch (registerRequest) {
        case ShopRegisterRequest():
          firebaseAuth.signOut();
          return null;
        case CustomerRegisterRequest():
          firebaseAuth.signOut();
          return null;
        case TouristGuideRegisterRequest():
          firebaseAuth.signOut();
          return null;
      }
    } catch (e, stk) {
      print(e);
      print(stk);
      rethrow;
    }
  }

  DocumentReference<Map<String, dynamic>> getCurrentCustomerDoc() =>
      FirebaseFirestore.instance
          .collection(FirebaseConstants.usersCollection)
          .doc(AuthRepository(ref).getCurrentUser!.uid);

  Future<void> createAdminUser() async {
    var req = const UserResponseDTO(
        userId: "",
        personalImageURL: "",
        name: "admin",
        email: "admin@admin.com",
        password: "1231231",
        userRole: UserRoleEnum.admin,
        phoneNumber: '',
        addressString: '',
        addressURL: '');
    final credentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: req.email, password: req.password);
    if (credentials.user != null) {
      final personalImage = await uploadPersonalImage(
          req.personalImageURL, credentials.user!.uid);
      await getCurrentCustomerDoc().set(req
          .copyWith(
              userId: credentials.user!.uid, personalImageURL: personalImage)
          .toMap());
    }
    await firebaseAuth.signOut();
  }

  Future<UserRole> signIn(LoginRequest loginReqModel) async {
    try {
      var userCredentials = (await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: loginReqModel.email, password: loginReqModel.password));
      if (userCredentials.user == null) {
        throw Exception("User is Null");
      }

      //TODO: remove comment
/*
      if (!userCredentials.user!.emailVerified) {
        await firebaseAuth.signOut();
        throw EmailVerificationException(ref
            .read(localizationProvider)
            .pleaseVerifyYourEmailViaClickingTheSentMessage);
      }
      */

      var userData = await getUserTypeDoc();
      return switch (userData) {
        Admin() => userData,
        Customer() => userData,
        Shop() => await checkUserApproval(userData),
        TouristGuide() => await checkUserApproval(userData),
      };
    } on Exception {
      rethrow;
    }
  }

  Future<bool> resendVerificationEmail(LoginRequest loginRequest) async {
    var userCredentials = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: loginRequest.email, password: loginRequest.password));
    await userCredentials.user?.sendEmailVerification();
    firebaseAuth.signOut();
    return true;
  }

  Stream<List<UserResponseDTO>> getPendingRegisterRequestsStream() =>
      firebaseFireStore
          .collection(FirebaseConstants.usersCollection)
          .where(UserResponseDTO.firebaseApproved, isNull: true)
          .where(UserResponseDTO.firebaseUserRole,
              isNotEqualTo: UserRoleEnum.customer.toValue())
          .snapshots()
          .asyncMap((e) =>
              e.docs.map((e) => UserResponseDTO.fromMap(e.data())).toList());

  Stream<List<UserResponseDTO>> getTouristGuidesStream() => firebaseFireStore
      .collection(FirebaseConstants.usersCollection)
      .where(UserResponseDTO.firebaseUserRole,
          isEqualTo: UserRoleEnum.touristGuide.toValue())
      .snapshots()
      .asyncMap((event) =>
          event.docs.map((e) => UserResponseDTO.fromMap(e.data())).toList());

  Future<UserRole> checkUserApproval(UserRole user) async {
    if (user.runtimeType == Shop) {
      if ((user as Shop).approved == null) {
        await signOut();
        throw Exception(ref
            .read(localizationProvider)
            .exceptionUserIsNotApprovedByTheAdminYet);
      } else if (!user.approved!) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionUserHasBeenRejectedByTheAdmin);
      }
      return user;
    }
    if ((user as TouristGuide).approved == null) {
      await signOut();
      throw Exception(ref
          .read(localizationProvider)
          .exceptionUserIsNotApprovedByTheAdminYet);
    } else if (!user.approved!) {
      throw Exception(ref
          .read(localizationProvider)
          .exceptionUserHasBeenRejectedByTheAdmin);
    }
    return user;
  }

  Future<bool> disapproveUserByID(String userID) async {
    try {
      firebaseFireStore
          .collection(FirebaseConstants.usersCollection)
          .doc(userID)
          .update({UserResponseDTO.firebaseApproved: false});
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> approveUserByID(String userID) async {
    try {
      firebaseFireStore
          .collection(FirebaseConstants.usersCollection)
          .doc(userID)
          .update({UserResponseDTO.firebaseApproved: true});
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<UserResponseDTO> getUserInfoById(String userId) async {
    return UserResponseDTO.fromMap((await firebaseFireStore
            .collection(FirebaseConstants.usersCollection)
            .doc(userId)
            .get())
        .data()!);
  }

  Future<String> getUserNameById(String userId) async {
    return (await firebaseFireStore
            .collection(FirebaseConstants.usersCollection)
            .doc(userId)
            .get())
        .get(UserResponseDTO.firebaseName);
  }

  Stream<UserResponseDTO> getUserInfoByIdStream(String userId) {
    return firebaseFireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .asyncMap((event) => UserResponseDTO.fromMap(event.data()!));
  }

  Future<bool> updateUser(UserResponseDTO updatedInfo, String userId) async {
    await firebaseFireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .update(updatedInfo.toMap());
    return true;
  }

  Future<void> sendResetPasswordEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> updateUserImage(String imagePath, String userId) async {
    var result = await uploadPersonalImage(imagePath, userId);
    await firebaseFireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .update({UserResponseDTO.firebasePersonalImageURL: result});
    return true;
  }

  Future<String> uploadPersonalImage(String imagePath, String userId) async {
    final ref = firebaseStorage
        .ref()
        .child("${FirebaseConstants.profileImagesStorage}/$userId");
    var image = imagePath.trim().isEmpty
        ? (await rootBundle.load(ImageAssetsManager.defaultProfileImage))
            .buffer
            .asUint8List()
        : File(imagePath).readAsBytesSync();
    var task = await ref.putData(image, SettableMetadata(contentType: "jpg"));
    return task.ref.getDownloadURL();
  }

  Future<void> signOut() async => await firebaseAuth.signOut();

  Future<void> updateUserEmail() async {
    await firebaseFireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .update(
            {UserResponseDTO.firebaseEmail: firebaseAuth.currentUser!.email!});
  }

  Future<UserRole> getUserTypeDoc() async {
    try {
      var userID = getCurrentUser?.uid ?? " ";
      if ((await FirebaseFirestore.instance
              .collection(FirebaseConstants.usersCollection)
              .doc(userID)
              .get())
          .exists) {
        var userData = UserResponseDTO.fromMap((await FirebaseFirestore.instance
                .collection(FirebaseConstants.usersCollection)
                .doc(userID)
                .get())
            .data()!);
        if (userData.email != firebaseAuth.currentUser!.email!) {
          updateUserEmail();
          userData = userData.copyWith(email: firebaseAuth.currentUser!.email!);
        }
        switch (userData.userRole) {
          case UserRoleEnum.admin:
            return Admin(
                user: getCurrentUser!,
                personalImageURL: userData.personalImageURL,
                name: userData.name,
                email: userData.email,
                password: userData.password,
                addressString: userData.addressString,
                phoneNumber: userData.phoneNumber);
          case UserRoleEnum.customer:
            return Customer(
                user: getCurrentUser!,
                personalImageURL: userData.personalImageURL,
                phoneNumber: userData.phoneNumber,
                name: userData.name,
                email: userData.email,
                password: userData.password,
                addressString: userData.addressString);
          case UserRoleEnum.shop:
            return Shop(
                description: userData.description!,
                approved: userData.approved,
                personalImageURL: userData.personalImageURL,
                user: getCurrentUser!,
                name: userData.name,
                email: userData.email,
                password: userData.password,
                addressString: userData.addressString,
                addressURL: userData.addressURL!,
                phoneNumber: userData.phoneNumber,
                shopType: userData.shopType!);
          case UserRoleEnum.touristGuide:
            return TouristGuide(
                description: userData.description!,
                approved: userData.approved,
                personalImageURL: userData.personalImageURL,
                user: getCurrentUser!,
                name: userData.name,
                email: userData.email,
                password: userData.password,
                addressString: userData.addressString,
                addressURL: userData.addressURL,
                phoneNumber: userData.phoneNumber,
                additionalPhoneNumber: userData.whatsAppPhoneNumber!);
        }
      }
      throw Exception("User Document Does Not Exist");
    } on Exception {
      rethrow;
    }
  }
}
