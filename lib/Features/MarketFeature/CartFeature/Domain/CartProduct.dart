import 'package:dart_mappable/dart_mappable.dart';

import '../../ShopFeature/Domain/Product.dart';
import '../../ShopFeature/Domain/ShopOverview.dart';

part 'CartProduct.mapper.dart';

@MappableClass()
class CartProductDTO with CartProductDTOMappable {
  final String productId;
  final int amount;

  const CartProductDTO({required this.productId, required this.amount});

  CartProduct toCartProductWithShopOverview(
          ProductDTO product, ShopOverview shopOverview) =>
      CartProduct(product: product.toProduct(shopOverview), amount: amount);
}

@MappableClass()
class CartProduct with CartProductMappable {
  final Product product;
  final int amount;

  const CartProduct({required this.product, required this.amount});

  double get totalRaw => amount * product.price;

  CartProductDTO toDTO() =>
      CartProductDTO(productId: product.productId, amount: amount);
}
