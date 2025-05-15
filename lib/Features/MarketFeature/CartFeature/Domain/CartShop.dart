import 'package:baha_platform/Features/MarketFeature/CartFeature/Domain/CartProduct.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../ShopFeature/Domain/Product.dart';
import '../../ShopFeature/Domain/ShopOverview.dart';

part 'CartShop.mapper.dart';

@MappableClass()
class CartShopDTO with CartShopDTOMappable {
  final String shopOverview;
  final IList<CartProductDTO> products;
  final bool takeFromStore;
  final bool? state;

  const CartShopDTO(
      {required this.shopOverview,
      required this.takeFromStore,
      required this.products,
      this.state});

  CartShop toCartShopWithOverview(
          ShopOverview overview, List<ProductDTO> fetchedProducts) =>
      CartShop(
          takeFromStore: takeFromStore,
          shopOverview: overview,
          products: products
              .mapIndexedAndLast((index, item, isLast) =>
                  item.toCartProductWithShopOverview(
                      fetchedProducts.elementAt(index), overview))
              .toIList());

  static const fromMap = CartShopDTOMapper.fromMap;
}

@MappableClass()
class CartShop with CartShopMappable {
  final ShopOverview shopOverview;
  final IList<CartProduct> products;
  final bool takeFromStore;
  final bool? state;

  const CartShop(
      {required this.shopOverview,
      required this.takeFromStore,
      required this.products,
      this.state});

  double get totalRaw => products.fold(
        0.0,
        (previousValue, element) => previousValue + element.totalRaw,
      );

  CartShopDTO toDTO() => CartShopDTO(
      takeFromStore: takeFromStore,
      shopOverview: shopOverview.shopId,
      products: products.map((element) => element.toDTO()).toIList());

  List<CartProductDTO> get cartProductDTOs =>
      products.map((element) => element.toDTO()).toList();

  CartShop addProduct(Product product, int amount) {
    return copyWith(
        products: products.replaceFirstWhere(
            (item) => item.product.productId == product.productId,
            (item) => item == null
                ? CartProduct(product: product, amount: amount)
                : item.copyWith(amount: amount),
            addIfNotFound: true));
  }

  CartShop removeProduct(Product product) {
    var productIndex = products.indexWhere(
        (element) => element.product.productId == product.productId);
    if (productIndex < 0) return this;

    return copyWith(products: products.removeAt(productIndex));

    /*
    if (products.elementAt(productIndex).amount == 1) {
    }
    return copyWith(
        products: products.replace(
      productIndex,
      products
          .elementAt(productIndex)
          .copyWith(amount: products.elementAt(productIndex).amount - 1),
    ));

     */
  }
}
