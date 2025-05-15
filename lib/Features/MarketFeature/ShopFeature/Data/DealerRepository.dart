import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/FirebaseConstants.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../AuthenticationFeature/Domain/UserRole.dart';
import '../Domain/Product.dart';
import '../Domain/ShopOverview.dart';

class ShopRepository extends AbstractRepository {
  final Ref ref;

  ShopRepository({required this.ref});

  Stream<Iterable<ProductDTO>> _getShopProductsDTOs(String shopId) {
    return firebaseFireStore
        .collection(FirebaseConstants.productsCollection)
        .where(ProductDTO.firebaseShopOverview, isEqualTo: shopId)
        .snapshots()
        .asyncMap(
            (event) => event.docs.map((e) => ProductDTO.fromMap(e.data())));
  }

  Stream<IList<Product>> getShopProducts(ShopOverview shopOverview) {
    var shopProductsDTO = _getShopProductsDTOs(shopOverview.shopId);
    return shopProductsDTO.asyncMap((event) => event
        .map((e) => e.toProduct(shopOverview))
        .where((element) => !element.isDeleted)
        .toIList());
  }

  Stream<List<ShopOverview>> getShopsOverviews({ShopTypeEnum? shopType}) {
    return shopType == null
        ? firebaseFireStore
            .collection(FirebaseConstants.usersCollection)
            .where(UserResponseDTO.firebaseUserRole,
                isEqualTo: UserRoleEnum.shop.toValue())
            .snapshots()
            .asyncMap((event) {
            return event.docs.map((e) {
              var shop = UserResponseDTO.fromMap(e.data());
              return ShopOverview(
                  personalImageURL: shop.personalImageURL,
                  shopId: e.id,
                  shopName: shop.name,
                  shopType: shop.shopType!);
            }).toList();
          })
        : firebaseFireStore
            .collection(FirebaseConstants.usersCollection)
            .where(UserResponseDTO.firebaseUserRole,
                isEqualTo: UserRoleEnum.shop.toValue())
            .where(UserResponseDTO.firebaseShopType,
                isEqualTo: shopType.toValue())
            .snapshots()
            .asyncMap((event) {
            return event.docs.map((e) {
              var shop = UserResponseDTO.fromMap(e.data());
              return ShopOverview(
                  personalImageURL: shop.personalImageURL,
                  shopId: e.id,
                  shopName: shop.name,
                  shopType: shop.shopType!);
            }).toList();
          });
  }

  Future<ShopOverview> getShopOverviewById(String shopId) async {
    var result = UserResponseDTO.fromMap((await firebaseFireStore
            .collection(FirebaseConstants.usersCollection)
            .doc(shopId)
            .get())
        .data()!);
    return ShopOverview(
        personalImageURL: result.personalImageURL,
        shopId: shopId,
        shopName: result.name,
        shopType: result.shopType!);
  }

  Future<List<ShopOverview>> getShopOverviewByIds(List<String> shopsId) async {
    if (shopsId.isEmpty) return [];
    var shopsOverviews = (await firebaseFireStore
            .collection(FirebaseConstants.usersCollection)
            .where(UserResponseDTO.firebaseUserId, whereIn: shopsId)
            .get())
        .docs
        .map((e) => ShopOverview.fromUserResponseDTOMap(e.data()));

    return shopsId.map(
      (e) {
        return shopsOverviews.firstWhere((element) => element.shopId == e);
      },
    ).toList();
  }
}
