import 'package:camera/camera.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:video_player/video_player.dart';

part 'StoryCaptureModel.mapper.dart';

@MappableClass()
class StoryCaptureModel with StoryCaptureModelMappable {
  final XFile? selectedFile;
  final VideoPlayerController? videoController;

  const StoryCaptureModel({this.selectedFile, this.videoController});

  factory StoryCaptureModel.empty() => const StoryCaptureModel();
}
