import 'package:baha_platform/Features/MarketFeature/CartFeature/Domain/Order.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/FirebaseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as CF;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ShopFeature/Domain/Product.dart';

class OrdersRepository extends AbstractRepository {
  final Ref ref;

  OrdersRepository({required this.ref});

  Stream<IList<Order>> shopCustomersOrdersStream(String shopId) =>
      firebaseFireStore
          .collection(FirebaseConstants.ordersCollection)
          .where(OrderDTO.firebaseShopId, isEqualTo: shopId)
          .where(OrderDTO.firebaseState, isNull: true)
          .snapshots()
          .asyncMap(
        (event) async {
          var ordersDTO = event.docs.map((e) => OrderDTO.fromMap(e.data()));
          var shopsOverviews = ref
              .read(repositoryClientProvider)
              .shopRepository
              .getShopOverviewByIds(ordersDTO.map((e) => e.shopId).toList());
          var customers = ordersDTO
              .map((e) => ref
                  .read(repositoryClientProvider)
                  .authRepository
                  .getUserInfoById(e.customerId))
              .wait;
          var products = ordersDTO
              .map((order) => order.products
                  .map((product) => ref
                      .read(repositoryClientProvider)
                      .productsRepository
                      .getProductDTOById(product.productId))
                  .wait)
              .wait;

          var waitedShopsOverviews = await shopsOverviews;
          var waitedCustomers = await customers;
          var waitedProduct = await products;

          return ordersDTO
              .mapIndexedAndLast((index, item, isLast) => item.toOrder(
                  shopOverview: waitedShopsOverviews.elementAt(index),
                  customerInfo: waitedCustomers.elementAt(index),
                  fetchedProducts: waitedProduct.elementAt(index)))
              .toIList();
        },
      );

  Future<IList<Order>> shopCustomersOrdersHistory(String shopId) async =>
      (await (await firebaseFireStore
                  .collection(FirebaseConstants.ordersCollection)
                  .where(OrderDTO.firebaseShopId, isEqualTo: shopId)
                  .where(OrderDTO.firebaseState, isNull: false)
                  .get())
              .docs
              .map((e) async {
        var orderDTO = OrderDTO.fromMap(e.data());
        var shopsOverviews = ref
            .read(repositoryClientProvider)
            .shopRepository
            .getShopOverviewById(orderDTO.shopId);
        var customer = ref
            .read(repositoryClientProvider)
            .authRepository
            .getUserInfoById(orderDTO.customerId);

        var products = await orderDTO.products
            .map((product) => ref
                .read(repositoryClientProvider)
                .productsRepository
                .getProductDTOById(product.productId))
            .wait;

        return orderDTO.toOrder(
            shopOverview: (await shopsOverviews),
            customerInfo: await customer,
            fetchedProducts: products);
      }).wait)
          .toIList();

  Future<bool> setOrderState(bool state, Order order) async {
    firebaseFireStore
        .collection(FirebaseConstants.ordersCollection)
        .doc(order.orderId)
        .update({OrderDTO.firebaseState: state});
    if (!state) {
      try {
        await order.products
            .map((e) => firebaseFireStore
                    .collection(FirebaseConstants.productsCollection)
                    .doc(e.product.productId)
                    .update({
                  ProductDTO.firebaseInStock: CF.FieldValue.increment(e.amount)
                }))
            .wait;
      } catch (e, stk) {
        print(e);
      }
    }
    return true;
  }

  Future<List<Order>> customerOrdersHistory(
      String customerId, bool isResolved) async {
    var customer = ref
        .read(repositoryClientProvider)
        .authRepository
        .getUserInfoById(customerId);
    return (await (await firebaseFireStore
                .collection(FirebaseConstants.ordersCollection)
                .where(OrderDTO.firebaseCustomerId, isEqualTo: customerId)
                .get())
            .docs
            .map((e) async {
      var orderDTO = OrderDTO.fromMap(e.data());
      var shopsOverviews = ref
          .read(repositoryClientProvider)
          .shopRepository
          .getShopOverviewById(orderDTO.shopId);

      var products = await orderDTO.products
          .map((product) => ref
              .read(repositoryClientProvider)
              .productsRepository
              .getProductDTOById(product.productId))
          .wait;
      return orderDTO.toOrder(
          shopOverview: (await shopsOverviews),
          customerInfo: await customer,
          fetchedProducts: products);
    }).wait)
        .where((element) =>
            isResolved ? element.state != null : element.state == null)
        .toList();
  }
}
