import 'package:baha_platform/Features/MarketFeature/CartFeature/Domain/Order.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../ShopFeature/Domain/Product.dart';
import '../../ShopFeature/Domain/ShopOverview.dart';
import 'CartProduct.dart';
import 'CartShop.dart';

part 'Cart.mapper.dart';

@MappableClass()
class CartDTO with CartDTOMappable {
  final String customerId;
  final IList<CartShopDTO> cartShops;

  const CartDTO({required this.customerId, required this.cartShops});

  factory CartDTO.empty(String customerId) =>
      CartDTO(customerId: customerId, cartShops: IList());

  static get firebaseCustomerId => "customerId";

  Cart toCart(
      List<ShopOverview> shopsOverviews, List<List<ProductDTO>> shopsProducts) {
    List<CartShop> cartConvertedShops = [];
    for (int i = 0; i < shopsOverviews.length; i++) {
      cartConvertedShops.add(cartShops.elementAt(i).toCartShopWithOverview(
          shopsOverviews.elementAt(i), shopsProducts.elementAt(i)));
    }
    return Cart(
        customerId: customerId, cartShops: cartConvertedShops.toIList());
  }

  List<CartProductDTO> reduceOrderedProducts() {
    return cartShops
        .map((element) => element.products)
        .reduce((value, element) => value.addAll(element))
        .toList();
  }

  List<OrderDTO> toOrdersDTOs() => cartShops
      .map((element) => OrderDTO(
          takeFromStore: element.takeFromStore,
          orderId: "",
          orderTime: DateTime.now(),
          shopId: element.shopOverview,
          customerId: customerId,
          products: element.products.toList()))
      .toList();

  static const fromMap = CartDTOMapper.fromMap;
}

@MappableClass()
class Cart with CartMappable {
  final String customerId;
  final IList<CartShop> cartShops;

  const Cart({required this.customerId, required this.cartShops});

  double get totalRaw => cartShops.fold(
      0, (previousValue, element) => previousValue + element.totalRaw);

  List<OrderDTO> toOrdersDTOs() => cartShops
      .map((element) => OrderDTO(
          takeFromStore: element.takeFromStore,
          orderId: "",
          orderTime: DateTime.now(),
          shopId: element.shopOverview.shopId,
          customerId: customerId,
          products: element.cartProductDTOs))
      .toList();

  CartDTO toDTO() => CartDTO(
      customerId: customerId,
      cartShops: cartShops.map((element) => element.toDTO()).toIList());

  List<CartProduct> reduceOrderedProducts() {
    return cartShops
        .map((element) => element.products)
        .reduce((value, element) => value.addAll(element))
        .toList();
  }

  Cart copyWithNewShop(Product product, int amount) {
    return copyWith(
        cartShops: cartShops.add(CartShop(
            takeFromStore: false,
            shopOverview: product.shopOverview,
            products: IList([CartProduct(product: product, amount: amount)]))));
  }

  Cart copyWithNewProduct(Product product, int shopIndex, int amount) {
    return copyWith(
        cartShops: cartShops.replace(shopIndex,
            cartShops.elementAt(shopIndex).addProduct(product, amount)));
  }

  Cart copyWithRemoveProduct(Product product, int shopIndex) {
    var updatedCart = copyWith(
        cartShops: cartShops.replace(
            shopIndex, cartShops.elementAt(shopIndex).removeProduct(product)));
    return updatedCart.cartShops.elementAt(shopIndex).products.isEmpty
        ? updatedCart.copyWith(
            cartShops: updatedCart.cartShops.removeAt(shopIndex))
        : updatedCart;
  }
}
