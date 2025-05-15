// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductManagementNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productManagerNotifierHash() =>
    r'6d79b0143b22a39761b4ca27f5814d5a4ead3d3d';

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

abstract class _$ProductManagerNotifier
    extends BuildlessAutoDisposeNotifier<ProductDTO> {
  late final ProductDTO? productDTO;

  ProductDTO build({
    ProductDTO? productDTO,
  });
}

/// See also [ProductManagerNotifier].
@ProviderFor(ProductManagerNotifier)
const productManagerNotifierProvider = ProductManagerNotifierFamily();

/// See also [ProductManagerNotifier].
class ProductManagerNotifierFamily extends Family<ProductDTO> {
  /// See also [ProductManagerNotifier].
  const ProductManagerNotifierFamily();

  /// See also [ProductManagerNotifier].
  ProductManagerNotifierProvider call({
    ProductDTO? productDTO,
  }) {
    return ProductManagerNotifierProvider(
      productDTO: productDTO,
    );
  }

  @override
  ProductManagerNotifierProvider getProviderOverride(
    covariant ProductManagerNotifierProvider provider,
  ) {
    return call(
      productDTO: provider.productDTO,
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
  String? get name => r'productManagerNotifierProvider';
}

/// See also [ProductManagerNotifier].
class ProductManagerNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ProductManagerNotifier, ProductDTO> {
  /// See also [ProductManagerNotifier].
  ProductManagerNotifierProvider({
    ProductDTO? productDTO,
  }) : this._internal(
          () => ProductManagerNotifier()..productDTO = productDTO,
          from: productManagerNotifierProvider,
          name: r'productManagerNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productManagerNotifierHash,
          dependencies: ProductManagerNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProductManagerNotifierFamily._allTransitiveDependencies,
          productDTO: productDTO,
        );

  ProductManagerNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productDTO,
  }) : super.internal();

  final ProductDTO? productDTO;

  @override
  ProductDTO runNotifierBuild(
    covariant ProductManagerNotifier notifier,
  ) {
    return notifier.build(
      productDTO: productDTO,
    );
  }

  @override
  Override overrideWith(ProductManagerNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductManagerNotifierProvider._internal(
        () => create()..productDTO = productDTO,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productDTO: productDTO,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProductManagerNotifier, ProductDTO>
      createElement() {
    return _ProductManagerNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductManagerNotifierProvider &&
        other.productDTO == productDTO;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productDTO.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductManagerNotifierRef on AutoDisposeNotifierProviderRef<ProductDTO> {
  /// The parameter `productDTO` of this provider.
  ProductDTO? get productDTO;
}

class _ProductManagerNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ProductManagerNotifier,
        ProductDTO> with ProductManagerNotifierRef {
  _ProductManagerNotifierProviderElement(super.provider);

  @override
  ProductDTO? get productDTO =>
      (origin as ProductManagerNotifierProvider).productDTO;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
