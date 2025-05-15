import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../_SharedData/LocalizedString.dart';

part 'UserRole.mapper.dart';

@MappableEnum()
enum UserRoleEnum { admin, customer, shop, touristGuide }

@MappableEnum()
enum ShopTypeEnum { productiveFamilyShop, agriculturalShop, artisanShop }

@MappableClass()
sealed class UserRole with UserRoleMappable {
  final User? user;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String addressString;
  final String personalImageURL;

  const UserRole(
      {this.user,
      required this.personalImageURL,
      required this.addressString,
      required this.phoneNumber,
      required this.name,
      required this.email,
      required this.password});

  @override
  String toString() {
    return 'Customer{user: $user, name: $name, email: $email, password: $password}';
  }
}

@MappableClass()
class Admin extends UserRole with AdminMappable {
  const Admin(
      {super.user,
      required super.personalImageURL,
      required super.addressString,
      required super.phoneNumber,
      required super.name,
      required super.email,
      required super.password});

  static const fromMap = AdminMapper.fromMap;
}

@MappableClass()
class Customer extends UserRole with CustomerMappable {
  const Customer(
      {super.user,
      required super.personalImageURL,
      required super.name,
      required super.email,
      required super.password,
      required super.addressString,
      required super.phoneNumber});

  static const fromMap = CustomerMapper.fromMap;
}

@MappableClass()
class Shop extends UserRole with ShopMappable {
  final ShopTypeEnum shopType;
  final LocalizedString description;
  final String addressURL;
  final bool? approved;

  const Shop(
      {super.user,
      required super.personalImageURL,
      required super.name,
      required super.email,
      required super.password,
      required super.addressString,
      required this.addressURL,
      required this.description,
      required super.phoneNumber,
      required this.shopType,
      required this.approved});

  static const fromMap = ShopMapper.fromMap;
}

@MappableClass()
class TouristGuide extends UserRole with TouristGuideMappable {
  final String additionalPhoneNumber;
  final LocalizedString description;
  final String addressURL;
  final bool? approved;

  const TouristGuide(
      {super.user,
      required super.personalImageURL,
      required super.name,
      required super.email,
      required super.password,
      required super.addressString,
      required this.addressURL,
      required this.description,
      required super.phoneNumber,
      required this.additionalPhoneNumber,
      required this.approved});

  static const fromMap = TouristGuideMapper.fromMap;
}
