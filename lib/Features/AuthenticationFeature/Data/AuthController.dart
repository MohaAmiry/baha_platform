import 'package:baha_platform/ExceptionHandler/EmailVerificationException.dart';
import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/SharedOperations.dart';
import '../../_SharedData/AbstractDataRepository.dart';
import '../Domain/LoginEntityRequest.dart';
import '../Domain/RegisterRequest.dart';
import '../Domain/UserRole.dart';

part 'AuthController.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController with SharedUserOperations {
  @override
  FutureOr<UserRole?> build() async {
    try {
      return await ref
          .read(repositoryClientProvider)
          .authRepository
          .getUserTypeDoc();
    } on Exception {
      return null;
    }
  }

  Future<bool> signIn(LoginRequest request) async {
    state = const AsyncLoading();
    var result = await ref.operationPipeLine(
        func: () =>
            ref.read(repositoryClientProvider).authRepository.signIn(request));
    if (result.error.runtimeType == EmailVerificationException) {
      return false;
    }
    state = AsyncData(result.hasError ? null : result.value);
    return true;
  }

  Future<void> resendVerificationEmail(LoginRequest request) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .resendVerificationEmail(request));
  }

  Future<void> sendResetPasswordEmail(String email) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .sendResetPasswordEmail(email));
  }

  void validateRegisterRequest(RegisterRequest request) {
    if (!isValidUserName(request.name)) {
      throw Exception(ref.read(localizationProvider).exceptionEmptyUserName);
    }
    if (!isValidEmail(request.email)) {
      throw Exception(ref.read(localizationProvider).exceptionNotEmailForm);
    }
    if (!isValidPassword(request.password)) {
      throw Exception(ref
          .read(localizationProvider)
          .exceptionPasswordShorterThan6Characters);
    }
    if (!isValidNumber(request.phoneNumber)) {
      throw Exception(
          ref.read(localizationProvider).exceptionNotValidPhoneNumber);
    }
    if (!isValidUserName(request.addressString)) {
      throw Exception(ref.read(localizationProvider).exceptionEmptyAddress);
    }

    if (request.runtimeType == ShopRegisterRequest) {
      request as ShopRegisterRequest;
      if (!isValidURL(request.addressURL)) {
        throw Exception(
            ref.read(localizationProvider).exceptionNotValidAddressURL);
      }

      if (!isValidUserName(request.description.ar)) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionEmptyServiceProviderDescription);
      }
    }

    if (request.runtimeType == TouristGuideRegisterRequest) {
      request as TouristGuideRegisterRequest;
      if (!isValidUserName(request.description.ar)) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionEmptyServiceProviderDescription);
      }
      if (!isValidURL((request).addressURL)) {
        throw Exception(
            ref.read(localizationProvider).exceptionNotValidAddressURL);
      }

      if (!isValidNumber((request).whatsAppPhoneNumber)) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionNotValidWhatsAppPhoneNumber);
      }
    }
  }

  Future<bool> signUp(RegisterRequest request) async {
    state = const AsyncLoading();
    var res = await ref.operationPipeLine(func: () async {
      validateRegisterRequest(request);
      if (request.runtimeType == ShopRegisterRequest ||
          request.runtimeType == TouristGuideRegisterRequest) {
        request = await localizeRegisterRequest(request);
      }
      return ref.read(repositoryClientProvider).authRepository.signUp(request);
    });
    if (res.hasError) {
      state = const AsyncData(null);
      return false;
    }
    state = AsyncData(res.value);
    return true;
  }

  Future<RegisterRequest> localizeRegisterRequest(
      RegisterRequest request) async {
    if (request.runtimeType == ShopRegisterRequest) {
      request as ShopRegisterRequest;
      final localizedDescription = await ref
          .read(localizationRepositoryProvider)
          .requireValue
          .localizeString(request.description);
      request = request.copyWith(description: localizedDescription);
      return request;
    }
    request as TouristGuideRegisterRequest;
    final localizedDescription = await ref
        .read(localizationRepositoryProvider)
        .requireValue
        .localizeString(request.description);
    request = request.copyWith(description: localizedDescription);
    return request;
  }

  bool? validateServiceProviderApproval(UserRole userRole) {
    if (userRole.runtimeType == Shop) {
      return (userRole as Shop).approved;
    }
    return (userRole as TouristGuide).approved;
  }

  Future<void> signOut() async {
    await ref.read(repositoryClientProvider).authRepository.signOut();
    state = const AsyncData(null);
  }

  Future<void> disapproveUserByID(String userID) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .disapproveUserByID(userID));
  }

  Future<void> approveUserByID(String userID) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .approveUserByID(userID));
  }
}
