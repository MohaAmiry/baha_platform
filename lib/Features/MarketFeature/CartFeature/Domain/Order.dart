import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../ShopFeature/Domain/Product.dart';
import '../../ShopFeature/Domain/ShopOverview.dart';
import 'CartProduct.dart';

part 'Order.mapper.dart';

@MappableClass()
class OrderDTO with OrderDTOMappable {
  final String orderId;
  final DateTime orderTime;
  final String shopId;
  final String customerId;
  final List<CartProductDTO> products;
  final bool takeFromStore;
  final bool? state;

  const OrderDTO(
      {required this.orderId,
      required this.orderTime,
      required this.shopId,
      required this.customerId,
      required this.products,
      required this.takeFromStore,
      this.state});

  static const fromMap = OrderDTOMapper.fromMap;

  static get firebaseOrderId => "orderId";

  static get firebaseState => "state";

  static get firebaseShopId => "shopId";

  static get firebaseCustomerId => "customerId";

  Order toOrder(
          {required ShopOverview shopOverview,
          required List<ProductDTO> fetchedProducts,
          required UserResponseDTO customerInfo}) =>
      Order(
          state: state,
          orderId: orderId,
          orderTime: orderTime,
          takeFromStore: takeFromStore,
          shopOverview: shopOverview,
          customerInfo: customerInfo,
          products: products
              .mapIndexedAndLast((index, item, isLast) =>
                  item.toCartProductWithShopOverview(
                      fetchedProducts.elementAt(index), shopOverview))
              .toList());
}

@MappableClass()
class Order with OrderMappable {
  final String orderId;
  final DateTime orderTime;
  final ShopOverview shopOverview;
  final UserResponseDTO customerInfo;
  final List<CartProduct> products;
  final bool takeFromStore;
  final bool? state;

  String get deliveryString => takeFromStore ? "اخذ من المتجر" : "توصيل";

  double get totalRaw => products.fold(
      0.0, (previousValue, element) => previousValue + element.totalRaw);

  String getOtherId(String currentId) => currentId == shopOverview.shopId
      ? customerInfo.userId
      : shopOverview.shopId;

  String getOtherName(String currentName) =>
      currentName == shopOverview.shopName
          ? customerInfo.name
          : shopOverview.shopName;

  const Order(
      {required this.orderId,
      required this.takeFromStore,
      required this.orderTime,
      required this.shopOverview,
      required this.customerInfo,
      required this.products,
      this.state});
}
