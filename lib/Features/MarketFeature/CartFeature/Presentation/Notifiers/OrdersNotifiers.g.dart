// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrdersNotifiers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopCustomerOrdersHistoryHash() =>
    r'78efee98fd4ffe7ab91f8439b7fb0a60545f94d6';

/// See also [shopCustomerOrdersHistory].
@ProviderFor(shopCustomerOrdersHistory)
final shopCustomerOrdersHistoryProvider =
    AutoDisposeFutureProvider<IList<Order>>.internal(
  shopCustomerOrdersHistory,
  name: r'shopCustomerOrdersHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shopCustomerOrdersHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopCustomerOrdersHistoryRef
    = AutoDisposeFutureProviderRef<IList<Order>>;
String _$shopCustomerOrdersHash() =>
    r'f9d801c9dc79f256d092b890d766d8fe1228f4cd';

/// See also [ShopCustomerOrders].
@ProviderFor(ShopCustomerOrders)
final shopCustomerOrdersProvider = AutoDisposeStreamNotifierProvider<
    ShopCustomerOrders, IList<Order>>.internal(
  ShopCustomerOrders.new,
  name: r'shopCustomerOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shopCustomerOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShopCustomerOrders = AutoDisposeStreamNotifier<IList<Order>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
