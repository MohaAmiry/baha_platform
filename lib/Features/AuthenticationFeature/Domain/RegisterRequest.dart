import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:dart_mappable/dart_mappable.dart';

import 'UserRole.dart';

part 'RegisterRequest.mapper.dart';

@MappableClass()
sealed class RegisterRequest with RegisterRequestMappable {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String addressString;
  final UserRoleEnum userRole;
  final String phoneNumber;
  final String personalImageURL;
  final String addressURL;

  const RegisterRequest(
      {required this.userId,
      required this.personalImageURL,
      required this.addressURL,
      required this.phoneNumber,
      required this.addressString,
      required this.name,
      required this.email,
      required this.password,
      required this.userRole});
}

@MappableClass()
class ShopRegisterRequest extends RegisterRequest
    with ShopRegisterRequestMappable {
  final ShopTypeEnum shopType;
  final LocalizedString description;
  final bool? approved;

  const ShopRegisterRequest(
      {required super.userId,
      required super.addressString,
      required super.addressURL,
      required super.personalImageURL,
      required super.name,
      required super.email,
      required super.password,
      required super.phoneNumber,
      super.userRole = UserRoleEnum.shop,
      required this.description,
      this.approved,
      this.shopType = ShopTypeEnum.agriculturalShop});
}

@MappableClass()
class CustomerRegisterRequest extends RegisterRequest
    with CustomerRegisterRequestMappable {
  const CustomerRegisterRequest(
      {required super.userId,
      required super.addressString,
      required super.personalImageURL,
      required super.addressURL,
      required super.name,
      required super.email,
      required super.password,
      required super.phoneNumber,
      super.userRole = UserRoleEnum.customer});
}

@MappableClass()
class TouristGuideRegisterRequest extends RegisterRequest
    with TouristGuideRegisterRequestMappable {
  final String whatsAppPhoneNumber;
  final LocalizedString description;
  final bool? approved;

  const TouristGuideRegisterRequest(
      {required super.userId,
      required super.addressString,
      required super.name,
      required super.email,
      required super.password,
      required super.phoneNumber,
      required super.personalImageURL,
      super.userRole = UserRoleEnum.touristGuide,
      required super.addressURL,
      required this.whatsAppPhoneNumber,
      required this.description,
      this.approved});
}
