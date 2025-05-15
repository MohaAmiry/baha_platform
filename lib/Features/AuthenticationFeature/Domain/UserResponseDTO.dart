import 'package:baha_platform/Features/AuthenticationFeature/Domain/RegisterRequest.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:dart_mappable/dart_mappable.dart';

import 'UserRole.dart';

part 'UserResponseDTO.mapper.dart';

@MappableClass()
class UserResponseDTO with UserResponseDTOMappable {
  final String userId;
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String addressString;
  final String addressURL;
  final String? whatsAppPhoneNumber;
  final UserRoleEnum userRole;
  final ShopTypeEnum? shopType;
  final String personalImageURL;
  final LocalizedString? description;
  final bool? approved;

  const UserResponseDTO(
      {required this.userId,
      required this.personalImageURL,
      required this.email,
      required this.phoneNumber,
      required this.addressString,
      required this.addressURL,
      required this.password,
      required this.name,
      required this.userRole,
      this.description,
      this.shopType,
      this.whatsAppPhoneNumber,
      this.approved});

  factory UserResponseDTO.empty() => const UserResponseDTO(
      userId: "",
      personalImageURL: "",
      email: "",
      password: "",
      phoneNumber: "",
      addressString: "",
      addressURL: "",
      name: "",
      shopType: ShopTypeEnum.agriculturalShop,
      userRole: UserRoleEnum.customer);

  RegisterRequest toRegisterRequest(UserRoleEnum userRole) =>
      switch (userRole) {
        UserRoleEnum.admin => throw UnimplementedError(),
        UserRoleEnum.customer => CustomerRegisterRequest(
            userId: userId,
            addressURL: addressURL,
            personalImageURL: personalImageURL,
            addressString: addressString,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber),
        UserRoleEnum.shop => ShopRegisterRequest(
            description: description ?? const LocalizedString(en: "", ar: ""),
            userId: userId,
            addressString: addressString,
            personalImageURL: personalImageURL,
            addressURL: addressURL,
            name: name,
            email: email,
            approved: approved,
            password: password,
            phoneNumber: phoneNumber),
        UserRoleEnum.touristGuide => TouristGuideRegisterRequest(
            description: description ?? const LocalizedString(en: "", ar: ""),
            userId: userId,
            addressString: addressString,
            personalImageURL: personalImageURL,
            approved: approved,
            name: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            addressURL: addressURL,
            whatsAppPhoneNumber: whatsAppPhoneNumber ?? ""),
      };

  static const fromMap = UserResponseDTOMapper.fromMap;

  static get firebaseUserRole => "userRole";

  static get firebaseName => "name";

  static get firebaseApproved => "approved";

  static get firebaseUserId => "userId";

  static get firebaseShopType => "shopType";

  static get firebasePersonalImageURL => "personalImageURL";

  static get firebaseEmail => "email";
}

@MappableClass()
class CustomerOrderData with CustomerOrderDataMappable {
  final String name;
  final String? phoneNumber;
  final String? address;

  const CustomerOrderData(
      {required this.name, required this.phoneNumber, required this.address});
}
