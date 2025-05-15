import 'dart:io';

import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/StoriesFeature/Domain/Story.dart';
import 'package:baha_platform/Features/StoriesFeature/Domain/StoryCaptureModel.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'StoryCaptureNotifier.g.dart';

@riverpod
class StoryCaptureNotifier extends _$StoryCaptureNotifier {
  late final CameraController cameraController;

  @override
  Future<StoryCaptureModel> build({XFile? preSelection}) async {
    ref.onDispose(
      () {
        cameraController.dispose();
      },
    );
    if (preSelection != null) {
      var videoController = await isVideo(preSelection.path);
      if (videoController != null) {
        return StoryCaptureModel(
            selectedFile: preSelection, videoController: videoController);
      }
      return StoryCaptureModel(selectedFile: preSelection);
    }
    cameraController = CameraController(
        (await availableCameras()).first, ResolutionPreset.max,
        enableAudio: true);
    await cameraController.initialize();
    return const StoryCaptureModel();
  }

  Future<VideoPlayerController?> isVideo(String path) async {
    var res = await AsyncValue.guard(() => initializeVideoPlayer(path));
    if (res.hasError) return null;
    return res.requireValue;
  }

  Future<void> captureImage() async {
    final image = await cameraController.takePicture();
    state = AsyncData(StoryCaptureModel(selectedFile: image));
  }

  Future<bool> startVideoRecording() async {
    await cameraController.startVideoRecording();
    return true;
  }

  Future<VideoPlayerController> stopVideoRecording(Size size) async {
    final file = await cameraController.stopVideoRecording();
    var videoController = await initializeVideoPlayer(file.path);
    state = AsyncData(StoryCaptureModel(
        selectedFile: file, videoController: videoController));
    return videoController;
  }

  Future<VideoPlayerController> initializeVideoPlayer(String path) async {
    var s = VideoPlayerController.file(File(path));
    await [
      s.initialize(),
      s.play(),
      s.setLooping(true),
    ].wait;
    return s;
  }

  Future<void> discardStory() async {
    try {
      cameraController;
    } catch (e, stk) {
      cameraController = CameraController(
          (await availableCameras()).first, ResolutionPreset.max,
          enableAudio: true);
      await cameraController.initialize();
    }
    state.value?.videoController?.dispose();
    state = const AsyncData(StoryCaptureModel());
  }

  Future<bool> publishStory(ContentType contentType, String contentId) async {
    var result = await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .storiesRepository
            .publishStory(
                StoryDTO(
                    storyId: StoryDTO.buildStoryId(ref
                        .read(authControllerProvider)
                        .requireValue!
                        .user!
                        .uid),
                    userId: ref
                        .read(authControllerProvider)
                        .requireValue!
                        .user!
                        .uid,
                    storyURL: state.requireValue.selectedFile!.path,
                    isVideo: state.requireValue.videoController != null,
                    recordDate: Timestamp.fromDate(DateTime.now())),
                contentId,
                contentType));

    if (result.hasError || !result.hasValue) return false;

    return true;
  }
}
