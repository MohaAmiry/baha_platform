import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:baha_platform/Features/StoriesFeature/Presentation/Notifiers/StoryCaptureNotifier.dart';
import 'package:baha_platform/utils/Enums.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class StoryCaptureView extends ConsumerStatefulWidget {
  final ({ContentType contentType, String contentId}) contentMetaData;
  final XFile? withPreSelection;

  const StoryCaptureView(
      {super.key, this.withPreSelection, required this.contentMetaData});

  @override
  ConsumerState createState() => _StoryCaptureViewState();
}

class _StoryCaptureViewState extends ConsumerState<StoryCaptureView> {
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        storyCaptureNotifierProvider(preSelection: widget.withPreSelection);
    return ref.watch(provider).when(
          data: (data) {
            return Scaffold(
                appBar: AppBar(),
                backgroundColor: Colors.black,
                body: data.selectedFile == null
                    ? Stack(children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: ref
                                .watch(provider.notifier)
                                .cameraController
                                .value
                                .aspectRatio,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: ref
                                    .watch(provider.notifier)
                                    .cameraController
                                    .value
                                    .previewSize!
                                    .height,
                                height: ref
                                    .watch(provider.notifier)
                                    .cameraController
                                    .value
                                    .previewSize!
                                    .width,
                                child: CameraPreview(ref
                                    .watch(provider.notifier)
                                    .cameraController),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () =>
                                  ref.read(provider.notifier).captureImage(),
                              onLongPress: () {
                                ref
                                    .read(provider.notifier)
                                    .startVideoRecording();
                                setState(() {
                                  isRecording = true;
                                });
                              },
                              onLongPressUp: () async {
                                await ref
                                    .read(provider.notifier)
                                    .stopVideoRecording(
                                        MediaQuery.sizeOf(context));
                                setState(() {
                                  isRecording = false;
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isRecording ? Colors.red : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])
                    : buildCapturedContent(provider));
          },
          error: (error, stackTrace) => ErrorView(error: error),
          loading: () => const LoadingView(),
        );
  }

  Widget buildCapturedContent(StoryCaptureNotifierProvider provider) =>
      PopScope(
        canPop: ref.watch(provider).value?.selectedFile == null,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await ref.read(provider.notifier).discardStory();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ref.watch(provider).maybeWhen(
                  data: (data) {
                    if (data.selectedFile == null) return Container();

                    return data.videoController != null
                        ? Transform.scale(
                            scale: data.videoController!.value.aspectRatio,
                            child: Center(
                              child: AspectRatio(
                                  aspectRatio:
                                      data.videoController!.value.aspectRatio,
                                  child: VideoPlayer(data.videoController!)),
                            ),
                          )
                        : Center(
                            child: Image.file(File(data.selectedFile!.path)));
                  },
                  orElse: () => Container(),
                ),
            Positioned(
              bottom: AppSizeManager.s45,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * .9,
                child: ElevatedButton(
                  onPressed: () async {
                    var result = await ref.read(provider.notifier).publishStory(
                        widget.contentMetaData.contentType,
                        widget.contentMetaData.contentId);
                    if (result && context.mounted) {
                      context.router.maybePop();
                    }
                  },
                  child: Text(context.strings.publishStory),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}
