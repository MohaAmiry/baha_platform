sealed class Message {}

class SuccessfulMessage extends Message {
  String message;

  SuccessfulMessage(this.message);

  @override
  String toString() {
    return message;
  }
}

class FailedMessage extends Message {
  Exception message;
  StackTrace stackTrace;

  FailedMessage(this.message, this.stackTrace);

  @override
  String toString() {
    return message.toString().replaceAll("Exception", "").replaceAll(":", "");
  }
}

class PendingMessage extends Message {
  String message;

  PendingMessage(this.message);

  @override
  String toString() {
    return message;
  }
}
