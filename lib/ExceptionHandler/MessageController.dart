import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/Resouces/ValuesManager.dart';
import 'MessageTypes.dart';

part 'MessageController.g.dart';

enum GeneralStates { pending, failed, success }

@riverpod
class MessageController extends _$MessageController {
  @override
  void build(BuildContext context) {
    return;
  }

  void showToast(Message obj) {
    dismissToast();
    switch (obj) {
      case SuccessfulMessage():
        _buildToast(
            message: obj.toString(),
            duration: const Duration(seconds: 4),
            color: ColorManager.primary);
        break;
      case FailedMessage():
        _buildToast(
            message: obj.toString(),
            duration: const Duration(seconds: 4),
            color: ColorManager.errorContainer);
        break;
      case PendingMessage():
        _buildToast(
            message: obj.toString(), duration: const Duration(minutes: 5));
        break;
    }
  }

  void dismissToast() =>
      ref.read(toastProvider(context)).removeQueuedCustomToasts();

  void _buildToast({
    required String message,
    Duration duration = Durations.extralong4,
    Color color = ColorManager.surfaceBright,
  }) =>
      ref.read(toastProvider(context)).showToast(
          toastDuration: duration,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizeManager.s20),
            ),
            padding: const EdgeInsets.all(PaddingValuesManager.p10),
            child: Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: ColorManager.surface)),
          ));
}

var toastProvider = Provider.family
    .autoDispose((ref, BuildContext context) => FToast().init(context));
