import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'PendingRegisterRequestsProvider.g.dart';

@riverpod
class PendingRegisterRequestsNotifier
    extends _$PendingRegisterRequestsNotifier {
  @override
  Stream<List<UserResponseDTO>> build() {
    return ref
        .read(repositoryClientProvider)
        .authRepository
        .getPendingRegisterRequestsStream();
  }

  Future<void> approveUserById(String userId) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .approveUserByID(userId));
  }

  Future<void> disapproveUserById(String userId) async {
    await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .authRepository
            .disapproveUserByID(userId));
  }
}
