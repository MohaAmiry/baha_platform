import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../AuthenticationFeature/Domain/UserRole.dart';

part 'ShopOverview.mapper.dart';

@MappableClass()
class ShopOverview with ShopOverviewMappable {
  final String shopId;
  final String shopName;
  final String personalImageURL;
  final ShopTypeEnum shopType;

  const ShopOverview(
      {required this.shopId,
      required this.shopName,
      required this.personalImageURL,
      required this.shopType});

  static const fromMap = ShopOverviewMapper.fromMap;

  factory ShopOverview.fromUserResponseDTOMap(
          Map<String, dynamic> userResponse) =>
      ShopOverview(
          shopId: userResponse[UserResponseDTO.firebaseUserId],
          personalImageURL:
              userResponse[UserResponseDTO.firebasePersonalImageURL],
          shopName: userResponse[UserResponseDTO.firebaseName],
          shopType: ShopTypeEnumMapper.fromValue(
              userResponse[UserResponseDTO.firebaseShopType]));

  factory ShopOverview.fromShop(Shop shop) => ShopOverview(
      personalImageURL: shop.personalImageURL,
      shopId: shop.user!.uid,
      shopName: shop.name,
      shopType: shop.shopType);
}
