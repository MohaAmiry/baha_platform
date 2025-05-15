import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../Domain/Order.dart';

part 'CustomerOrdersNotifiers.g.dart';

@riverpod
Future<List<Order>> customerOrdersHistory(Ref ref, bool isResolved) async {
  return ref
      .read(repositoryClientProvider)
      .ordersRepository
      .customerOrdersHistory(
          ref.read(authControllerProvider).requireValue!.user!.uid, isResolved);
}
