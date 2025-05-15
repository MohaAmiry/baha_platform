import 'package:baha_platform/Features/MarketFeature/CartFeature/Domain/Order.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/FirebaseConstants.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ShopFeature/Domain/Product.dart';
import '../Domain/Cart.dart';
import '../Domain/CartProduct.dart';

class CartRepository extends AbstractRepository {
  final Ref ref;

  CartRepository({required this.ref});

  Future<Cart> getCustomerCart(String customerId) async {
    var result = await firebaseFireStore
        .collection(FirebaseConstants.cartsCollection)
        .doc(customerId)
        .get();
    if (!result.exists) {
      await firebaseFireStore
          .collection(FirebaseConstants.cartsCollection)
          .doc(customerId)
          .set(CartDTO.empty(customerId).toMap());
      return Cart(customerId: customerId, cartShops: IList());
    }
    var cartDTO = CartDTO.fromMap(result.data()!);
    var shopsOverviews = await ref
        .read(repositoryClientProvider)
        .shopRepository
        .getShopOverviewByIds(
            cartDTO.cartShops.map((element) => element.shopOverview).toList());
    var products = await cartDTO.cartShops
        .map((shop) => shop.products
            .map((product) => ref
                .read(repositoryClientProvider)
                .productsRepository
                .getProductDTOById(product.productId))
            .wait)
        .wait;
    return cartDTO.toCart(shopsOverviews, products);
  }

  Stream<Cart> getCustomerCartStream(String customerId) {
    return firebaseFireStore
        .collection(FirebaseConstants.cartsCollection)
        .doc(customerId)
        .snapshots()
        .asyncMap((event) async {
      if (!event.exists) {
        await firebaseFireStore
            .collection(FirebaseConstants.cartsCollection)
            .doc(customerId)
            .set(CartDTO.empty(customerId).toMap());
        return Cart(customerId: customerId, cartShops: IList());
      }
      var cartDTO = CartDTO.fromMap(event.data()!);
      var shopsOverviews = await ref
          .read(repositoryClientProvider)
          .shopRepository
          .getShopOverviewByIds(cartDTO.cartShops
              .map((element) => element.shopOverview)
              .toList());
      var products = await cartDTO.cartShops
          .map((shop) => shop.products
              .map((product) => ref
                  .read(repositoryClientProvider)
                  .productsRepository
                  .getProductDTOById(product.productId))
              .wait)
          .wait;
      return cartDTO.toCart(shopsOverviews, products);
    });
  }

  Future<bool> addProductToCart(
      Product product, String customerId, int amount) async {
    var currentCart = await getCustomerCart(customerId);
    var shopToAddTo = currentCart.cartShops.indexWhere((element) =>
        element.shopOverview.shopId == product.shopOverview.shopId);
    if (shopToAddTo < 0) {
      currentCart = currentCart.copyWithNewShop(product, amount);
    } else {
      currentCart =
          currentCart.copyWithNewProduct(product, shopToAddTo, amount);
    }
    await firebaseFireStore
        .collection(FirebaseConstants.cartsCollection)
        .doc(customerId)
        .set(currentCart.toDTO().toMap());
    return true;
  }

  Future<bool> setTakeFromStore(
      bool toState, String shopId, String customerId) async {
    var currentCart = await getCustomerCart(customerId);
    currentCart = currentCart.copyWith(
        cartShops: currentCart.cartShops.replaceFirstWhere(
            (item) => item.shopOverview.shopId == shopId,
            (item) => item!.copyWith(takeFromStore: toState),
            addIfNotFound: false));
    await firebaseFireStore
        .collection(FirebaseConstants.cartsCollection)
        .doc(customerId)
        .update(currentCart.toDTO().toMap());
    return true;
  }

  Future<bool> removeProductFromCart(Product product, String customerId) async {
    var currentCart = await getCustomerCart(customerId);
    var shopToRemoveFrom = currentCart.cartShops.indexWhere((element) =>
        element.shopOverview.shopId == product.shopOverview.shopId);
    if (shopToRemoveFrom == -1) {
      return true;
    }
    currentCart = currentCart.copyWithRemoveProduct(product, shopToRemoveFrom);
    await firebaseFireStore
        .collection(FirebaseConstants.cartsCollection)
        .doc(customerId)
        .update(currentCart.toDTO().toMap());
    return true;
  }

  Future<bool> confirmCustomerCart(Cart customerCart) async {
    if (customerCart.cartShops.isEmpty) return true;
    var orders = customerCart.toOrdersDTOs();
    var ordersDocs = await orders
        .map((element) => firebaseFireStore
            .collection(FirebaseConstants.ordersCollection)
            .add(element.toMap()))
        .wait;
    await ordersDocs
        .map(
            (element) => element.update({OrderDTO.firebaseOrderId: element.id}))
        .wait;
    await firebaseFireStore
        .collection(FirebaseConstants.cartsCollection)
        .doc(customerCart.customerId)
        .update(customerCart.copyWith(cartShops: IList()).toMap());

    return true;
  }


  Future<bool> setProductStock(String productId, bool updatedStock) async {
    await firebaseFireStore
        .collection(FirebaseConstants.productsCollection)
        .doc(productId)
        .update({ProductDTO.firebaseInStock: updatedStock});
    return true;
  }
}
