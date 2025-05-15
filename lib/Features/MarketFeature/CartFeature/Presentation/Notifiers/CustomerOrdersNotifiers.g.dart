// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerOrdersNotifiers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerOrdersHistoryHash() =>
    r'473fb3bbfffcf93dca07c621bbda91d93137c120';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [customerOrdersHistory].
@ProviderFor(customerOrdersHistory)
const customerOrdersHistoryProvider = CustomerOrdersHistoryFamily();

/// See also [customerOrdersHistory].
class CustomerOrdersHistoryFamily extends Family<AsyncValue<List<Order>>> {
  /// See also [customerOrdersHistory].
  const CustomerOrdersHistoryFamily();

  /// See also [customerOrdersHistory].
  CustomerOrdersHistoryProvider call(
    bool isResolved,
  ) {
    return CustomerOrdersHistoryProvider(
      isResolved,
    );
  }

  @override
  CustomerOrdersHistoryProvider getProviderOverride(
    covariant CustomerOrdersHistoryProvider provider,
  ) {
    return call(
      provider.isResolved,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerOrdersHistoryProvider';
}

/// See also [customerOrdersHistory].
class CustomerOrdersHistoryProvider
    extends AutoDisposeFutureProvider<List<Order>> {
  /// See also [customerOrdersHistory].
  CustomerOrdersHistoryProvider(
    bool isResolved,
  ) : this._internal(
          (ref) => customerOrdersHistory(
            ref as CustomerOrdersHistoryRef,
            isResolved,
          ),
          from: customerOrdersHistoryProvider,
          name: r'customerOrdersHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerOrdersHistoryHash,
          dependencies: CustomerOrdersHistoryFamily._dependencies,
          allTransitiveDependencies:
              CustomerOrdersHistoryFamily._allTransitiveDependencies,
          isResolved: isResolved,
        );

  CustomerOrdersHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isResolved,
  }) : super.internal();

  final bool isResolved;

  @override
  Override overrideWith(
    FutureOr<List<Order>> Function(CustomerOrdersHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerOrdersHistoryProvider._internal(
        (ref) => create(ref as CustomerOrdersHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isResolved: isResolved,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Order>> createElement() {
    return _CustomerOrdersHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerOrdersHistoryProvider &&
        other.isResolved == isResolved;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isResolved.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerOrdersHistoryRef on AutoDisposeFutureProviderRef<List<Order>> {
  /// The parameter `isResolved` of this provider.
  bool get isResolved;
}

class _CustomerOrdersHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Order>>
    with CustomerOrdersHistoryRef {
  _CustomerOrdersHistoryProviderElement(super.provider);

  @override
  bool get isResolved => (origin as CustomerOrdersHistoryProvider).isResolved;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
