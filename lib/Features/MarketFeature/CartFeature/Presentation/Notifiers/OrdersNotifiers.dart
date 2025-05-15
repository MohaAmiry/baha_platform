import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../Domain/Order.dart';

part 'OrdersNotifiers.g.dart';

@riverpod
class ShopCustomerOrders extends _$ShopCustomerOrders {
  @override
  Stream<IList<Order>> build() {
    return ref
        .read(repositoryClientProvider)
        .ordersRepository
        .shopCustomersOrdersStream(
            ref.read(authControllerProvider).requireValue!.user!.uid);
  }

  Future<bool> setOrderState(bool state, Order order) async {
    var result = await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .ordersRepository
            .setOrderState(state, order));
    if (result.hasError) return false;
    return true;
  }
}

@riverpod
Future<IList<Order>> shopCustomerOrdersHistory(
    ShopCustomerOrdersHistoryRef ref) async {
  return ref
      .read(repositoryClientProvider)
      .ordersRepository
      .shopCustomersOrdersHistory(
          ref.read(authControllerProvider).requireValue!.user!.uid);
}
