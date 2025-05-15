// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShopProviders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopAllProductsHash() => r'7fbd3056462248601cdd11203ea43d13b8278eb0';

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

/// See also [shopAllProducts].
@ProviderFor(shopAllProducts)
const shopAllProductsProvider = ShopAllProductsFamily();

/// See also [shopAllProducts].
class ShopAllProductsFamily extends Family<AsyncValue<IList<Product>>> {
  /// See also [shopAllProducts].
  const ShopAllProductsFamily();

  /// See also [shopAllProducts].
  ShopAllProductsProvider call(
    ShopOverview shopOverview,
  ) {
    return ShopAllProductsProvider(
      shopOverview,
    );
  }

  @override
  ShopAllProductsProvider getProviderOverride(
    covariant ShopAllProductsProvider provider,
  ) {
    return call(
      provider.shopOverview,
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
  String? get name => r'shopAllProductsProvider';
}

/// See also [shopAllProducts].
class ShopAllProductsProvider
    extends AutoDisposeStreamProvider<IList<Product>> {
  /// See also [shopAllProducts].
  ShopAllProductsProvider(
    ShopOverview shopOverview,
  ) : this._internal(
          (ref) => shopAllProducts(
            ref as ShopAllProductsRef,
            shopOverview,
          ),
          from: shopAllProductsProvider,
          name: r'shopAllProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shopAllProductsHash,
          dependencies: ShopAllProductsFamily._dependencies,
          allTransitiveDependencies:
              ShopAllProductsFamily._allTransitiveDependencies,
          shopOverview: shopOverview,
        );

  ShopAllProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopOverview,
  }) : super.internal();

  final ShopOverview shopOverview;

  @override
  Override overrideWith(
    Stream<IList<Product>> Function(ShopAllProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopAllProductsProvider._internal(
        (ref) => create(ref as ShopAllProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopOverview: shopOverview,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<IList<Product>> createElement() {
    return _ShopAllProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopAllProductsProvider &&
        other.shopOverview == shopOverview;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopOverview.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopAllProductsRef on AutoDisposeStreamProviderRef<IList<Product>> {
  /// The parameter `shopOverview` of this provider.
  ShopOverview get shopOverview;
}

class _ShopAllProductsProviderElement
    extends AutoDisposeStreamProviderElement<IList<Product>>
    with ShopAllProductsRef {
  _ShopAllProductsProviderElement(super.provider);

  @override
  ShopOverview get shopOverview =>
      (origin as ShopAllProductsProvider).shopOverview;
}

String _$productsByTypeHash() => r'04173c4908f7d597a225b03e2a9567268fca1fc6';

/// See also [productsByType].
@ProviderFor(productsByType)
const productsByTypeProvider = ProductsByTypeFamily();

/// See also [productsByType].
class ProductsByTypeFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [productsByType].
  const ProductsByTypeFamily();

  /// See also [productsByType].
  ProductsByTypeProvider call(
    ShopTypeEnum type,
  ) {
    return ProductsByTypeProvider(
      type,
    );
  }

  @override
  ProductsByTypeProvider getProviderOverride(
    covariant ProductsByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'productsByTypeProvider';
}

/// See also [productsByType].
class ProductsByTypeProvider extends AutoDisposeStreamProvider<List<Product>> {
  /// See also [productsByType].
  ProductsByTypeProvider(
    ShopTypeEnum type,
  ) : this._internal(
          (ref) => productsByType(
            ref as ProductsByTypeRef,
            type,
          ),
          from: productsByTypeProvider,
          name: r'productsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsByTypeHash,
          dependencies: ProductsByTypeFamily._dependencies,
          allTransitiveDependencies:
              ProductsByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  ProductsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ShopTypeEnum type;

  @override
  Override overrideWith(
    Stream<List<Product>> Function(ProductsByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByTypeProvider._internal(
        (ref) => create(ref as ProductsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Product>> createElement() {
    return _ProductsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsByTypeRef on AutoDisposeStreamProviderRef<List<Product>> {
  /// The parameter `type` of this provider.
  ShopTypeEnum get type;
}

class _ProductsByTypeProviderElement
    extends AutoDisposeStreamProviderElement<List<Product>>
    with ProductsByTypeRef {
  _ProductsByTypeProviderElement(super.provider);

  @override
  ShopTypeEnum get type => (origin as ProductsByTypeProvider).type;
}

String _$shopsOverviewByTypeHash() =>
    r'240e90e17ade8c11ecfe03a8a4103b9622fe0ddf';

/// See also [shopsOverviewByType].
@ProviderFor(shopsOverviewByType)
const shopsOverviewByTypeProvider = ShopsOverviewByTypeFamily();

/// See also [shopsOverviewByType].
class ShopsOverviewByTypeFamily extends Family<AsyncValue<List<ShopOverview>>> {
  /// See also [shopsOverviewByType].
  const ShopsOverviewByTypeFamily();

  /// See also [shopsOverviewByType].
  ShopsOverviewByTypeProvider call(
    ShopTypeEnum type,
  ) {
    return ShopsOverviewByTypeProvider(
      type,
    );
  }

  @override
  ShopsOverviewByTypeProvider getProviderOverride(
    covariant ShopsOverviewByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'shopsOverviewByTypeProvider';
}

/// See also [shopsOverviewByType].
class ShopsOverviewByTypeProvider
    extends AutoDisposeStreamProvider<List<ShopOverview>> {
  /// See also [shopsOverviewByType].
  ShopsOverviewByTypeProvider(
    ShopTypeEnum type,
  ) : this._internal(
          (ref) => shopsOverviewByType(
            ref as ShopsOverviewByTypeRef,
            type,
          ),
          from: shopsOverviewByTypeProvider,
          name: r'shopsOverviewByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shopsOverviewByTypeHash,
          dependencies: ShopsOverviewByTypeFamily._dependencies,
          allTransitiveDependencies:
              ShopsOverviewByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  ShopsOverviewByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ShopTypeEnum type;

  @override
  Override overrideWith(
    Stream<List<ShopOverview>> Function(ShopsOverviewByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopsOverviewByTypeProvider._internal(
        (ref) => create(ref as ShopsOverviewByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ShopOverview>> createElement() {
    return _ShopsOverviewByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopsOverviewByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopsOverviewByTypeRef
    on AutoDisposeStreamProviderRef<List<ShopOverview>> {
  /// The parameter `type` of this provider.
  ShopTypeEnum get type;
}

class _ShopsOverviewByTypeProviderElement
    extends AutoDisposeStreamProviderElement<List<ShopOverview>>
    with ShopsOverviewByTypeRef {
  _ShopsOverviewByTypeProviderElement(super.provider);

  @override
  ShopTypeEnum get type => (origin as ShopsOverviewByTypeProvider).type;
}

String _$shopInformationByIdHash() =>
    r'ea55f0531496e1e473e950c04b1fd212debbb9e0';

/// See also [shopInformationById].
@ProviderFor(shopInformationById)
const shopInformationByIdProvider = ShopInformationByIdFamily();

/// See also [shopInformationById].
class ShopInformationByIdFamily extends Family<AsyncValue<UserResponseDTO>> {
  /// See also [shopInformationById].
  const ShopInformationByIdFamily();

  /// See also [shopInformationById].
  ShopInformationByIdProvider call(
    String userId,
  ) {
    return ShopInformationByIdProvider(
      userId,
    );
  }

  @override
  ShopInformationByIdProvider getProviderOverride(
    covariant ShopInformationByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'shopInformationByIdProvider';
}

/// See also [shopInformationById].
class ShopInformationByIdProvider
    extends AutoDisposeStreamProvider<UserResponseDTO> {
  /// See also [shopInformationById].
  ShopInformationByIdProvider(
    String userId,
  ) : this._internal(
          (ref) => shopInformationById(
            ref as ShopInformationByIdRef,
            userId,
          ),
          from: shopInformationByIdProvider,
          name: r'shopInformationByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shopInformationByIdHash,
          dependencies: ShopInformationByIdFamily._dependencies,
          allTransitiveDependencies:
              ShopInformationByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  ShopInformationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<UserResponseDTO> Function(ShopInformationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopInformationByIdProvider._internal(
        (ref) => create(ref as ShopInformationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<UserResponseDTO> createElement() {
    return _ShopInformationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopInformationByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopInformationByIdRef on AutoDisposeStreamProviderRef<UserResponseDTO> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ShopInformationByIdProviderElement
    extends AutoDisposeStreamProviderElement<UserResponseDTO>
    with ShopInformationByIdRef {
  _ShopInformationByIdProviderElement(super.provider);

  @override
  String get userId => (origin as ShopInformationByIdProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
