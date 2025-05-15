import 'package:dart_mappable/dart_mappable.dart';

part 'LoginEntityRequest.mapper.dart';

@MappableClass()
class LoginRequest with LoginRequestMappable {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});
}
