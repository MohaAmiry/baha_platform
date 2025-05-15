import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/MarketFeature/CartFeature/Domain/CartProduct.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'ShopOverview.dart';

part 'Product.mapper.dart';

@MappableClass()
class ProductDTO with ProductDTOMappable {
  final String productId;
  final LocalizedString name;
  final LocalizedString description;
  final double price;
  final String shopOverview;
  final List<String> images;
  final bool inStock;
  final bool isDeleted;
  final ShopTypeEnum shopType;

  const ProductDTO(
      {required this.productId,
      required this.name,
      required this.description,
      required this.price,
      required this.shopOverview,
      required this.images,
      required this.inStock,
      required this.isDeleted,
      required this.shopType});

  static const fromMap = ProductDTOMapper.fromMap;

  static String get firebaseProductId => "productId";

  static String get firebaseImagesLink => "images";

  static String get firebaseShopOverview => "shopOverview";

  static String get firebaseInStock => "inStock";

  static String get firebaseIsDeleted => "isDeleted";

  static String get firebaseShopType => "shopType";

  factory ProductDTO.empty() => ProductDTO(
      productId: "",
      name: LocalizedString.empty(),
      description: LocalizedString.empty(),
      price: -1,
      shopOverview: "",
      shopType: ShopTypeEnum.artisanShop,
      images: [],
      inStock: true,
      isDeleted: false);

  factory ProductDTO.withShopOverview(String shopIdOverview) => ProductDTO(
      productId: "",
      name: LocalizedString.empty(),
      description: LocalizedString.empty(),
      price: -1,
      shopType: ShopTypeEnum.artisanShop,
      shopOverview: shopIdOverview,
      images: [],
      inStock: true,
      isDeleted: false);

  Product toProduct(ShopOverview shopOverview) => Product(
      productId: productId,
      name: name,
      description: description,
      shopType: shopType,
      price: price,
      shopOverview: shopOverview,
      images: images,
      inStock: inStock,
      isDeleted: isDeleted);
}

@MappableClass()
class Product with ProductMappable {
  final String productId;
  final LocalizedString name;
  final LocalizedString description;
  final ShopOverview shopOverview;
  final double price;
  final List<String> images;
  final bool inStock;
  final bool isDeleted;
  final ShopTypeEnum shopType;

  const Product(
      {required this.productId,
      required this.shopType,
      required this.description,
      required this.name,
      required this.price,
      required this.shopOverview,
      required this.images,
      required this.inStock,
      required this.isDeleted});

  static const fromMap = ProductMapper.fromMap;

  factory Product.fromDTO(Product product, ShopOverview shopOverview) =>
      Product(
          productId: product.productId,
          name: product.name,
          description: product.description,
          price: product.price,
          shopOverview: shopOverview,
          images: product.images,
          inStock: product.inStock,
          shopType: product.shopType,
          isDeleted: product.isDeleted);

  CartProduct toCartProductWithShopOverview(int amount) =>
      CartProduct(product: this, amount: amount);

  ProductDTO toDTO() => ProductDTO(
      productId: productId,
      description: description,
      shopType: shopType,
      name: name,
      price: price,
      shopOverview: shopOverview.shopId,
      images: images,
      inStock: inStock,
      isDeleted: isDeleted);
}
