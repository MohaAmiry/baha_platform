import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/Features/_SharedData/ImagePickerNotifier.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/SharedOperations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../Localization/LocalizationProvider.dart';
import '../../../../Localization/LocalizationRepository.dart';

part 'ProfileNotifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier with SharedUserOperations {
  @override
  Stream<UserResponseDTO> build() {
    return ref
        .read(repositoryClientProvider)
        .authRepository
        .getUserInfoByIdStream(
            ref.watch(authControllerProvider).value?.user?.uid ?? "ss");
  }

  Future<bool> updateUserInfo(UserResponseDTO updatedUser) async {
    var result = await ref.operationPipeLine(func: () async {
      validateUpdateRequest(updatedUser);
      if (updatedUser.userRole == UserRoleEnum.shop ||
          updatedUser.userRole == UserRoleEnum.touristGuide) {
        final localizedDescription = await ref
            .read(localizationRepositoryProvider)
            .requireValue
            .localizeString(updatedUser.description!);
        updatedUser = updatedUser.copyWith(description: localizedDescription);
      }
      return ref.read(repositoryClientProvider).authRepository.updateUser(
          updatedUser,
          ref.read(authControllerProvider).requireValue!.user!.uid);
    });
    return !result.hasError;
  }

  Future<void> updateUserImage() async {
    final selection =
        await ref.read(imagePickerNotifierProvider.notifier).pickProfileImage();
    if (selection == null) return;
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .updateUserImage(selection.path, state.requireValue.userId));
  }

  Future<void> removeUserImage() async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .updateUserImage("", state.requireValue.userId));
  }

  void validateUpdateRequest(UserResponseDTO updatedUser) {
    if (!isValidUserName(updatedUser.name)) {
      throw Exception(ref.read(localizationProvider).exceptionEmptyUserName);
    }
    if (!isValidEmail(updatedUser.email)) {
      throw Exception(ref.read(localizationProvider).exceptionNotEmailForm);
    }
    if (!isValidPassword(updatedUser.password)) {
      throw Exception(ref
          .read(localizationProvider)
          .exceptionPasswordShorterThan6Characters);
    }
    if (!isValidNumber(updatedUser.phoneNumber)) {
      throw Exception(
          ref.read(localizationProvider).exceptionNotValidPhoneNumber);
    }
    if (!isValidUserName(updatedUser.addressString)) {
      throw Exception(ref.read(localizationProvider).exceptionEmptyAddress);
    }
    if (updatedUser.userRole == UserRoleEnum.shop) {
      if (!isValidURL((updatedUser).addressURL)) {
        throw Exception(
            ref.read(localizationProvider).exceptionNotValidAddressURL);
      }
      if (!isValidUserName(updatedUser.description!.ar)) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionEmptyServiceProviderDescription);
      }
    }
    if (updatedUser.userRole == UserRoleEnum.touristGuide) {
      if (!isValidURL((updatedUser).addressURL)) {
        throw Exception(
            ref.read(localizationProvider).exceptionNotValidAddressURL);
      }
      if (!isValidUserName(updatedUser.description!.ar)) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionEmptyServiceProviderDescription);
      }
      if (!isValidNumber((updatedUser).whatsAppPhoneNumber!)) {
        throw Exception(ref
            .read(localizationProvider)
            .exceptionNotValidWhatsAppPhoneNumber);
      }
    }
  }
}
