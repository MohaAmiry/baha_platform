import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'TouristGuidesProvider.g.dart';

@riverpod
Stream<List<UserResponseDTO>> touristGuidesList(Ref ref) {
  return ref
      .read(repositoryClientProvider)
      .authRepository
      .getTouristGuidesStream();
}
