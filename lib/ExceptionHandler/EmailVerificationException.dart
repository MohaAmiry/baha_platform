class EmailVerificationException implements Exception {
  final dynamic message;

  EmailVerificationException(this.message);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
