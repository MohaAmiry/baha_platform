import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../Localization/LocalizationProvider.dart';
import 'MessageTypes.dart';

part 'MessageEmitter.g.dart';

@riverpod
class MessageEmitter extends _$MessageEmitter {
  @override
  Message? build() {
    return null;
  }

  void setMessage(Message? message) => state = message;

  void setPending({String? message}) => setMessage(
      PendingMessage(message ?? ref.read(localizationProvider).processing));

  void setFailed(
          {required Exception message, required StackTrace stackTrace}) =>
      setMessage(FailedMessage(message, stackTrace));

  void setSuccessfulMessage({String? message}) => setMessage(SuccessfulMessage(
      message ?? ref.read(localizationProvider).operationSucceeded));
}
