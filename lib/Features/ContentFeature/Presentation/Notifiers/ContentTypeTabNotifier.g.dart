// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContentTypeTabNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentTypeTabNotifierHash() =>
    r'eaee5f8fd6284e5c9b7917124ff78c142209e17c';

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

/// See also [contentTypeTabNotifier].
@ProviderFor(contentTypeTabNotifier)
const contentTypeTabNotifierProvider = ContentTypeTabNotifierFamily();

/// See also [contentTypeTabNotifier].
class ContentTypeTabNotifierFamily extends Family<AsyncValue<List<Content>>> {
  /// See also [contentTypeTabNotifier].
  const ContentTypeTabNotifierFamily();

  /// See also [contentTypeTabNotifier].
  ContentTypeTabNotifierProvider call(
    ContentType type,
  ) {
    return ContentTypeTabNotifierProvider(
      type,
    );
  }

  @override
  ContentTypeTabNotifierProvider getProviderOverride(
    covariant ContentTypeTabNotifierProvider provider,
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
  String? get name => r'contentTypeTabNotifierProvider';
}

/// See also [contentTypeTabNotifier].
class ContentTypeTabNotifierProvider
    extends AutoDisposeStreamProvider<List<Content>> {
  /// See also [contentTypeTabNotifier].
  ContentTypeTabNotifierProvider(
    ContentType type,
  ) : this._internal(
          (ref) => contentTypeTabNotifier(
            ref as ContentTypeTabNotifierRef,
            type,
          ),
          from: contentTypeTabNotifierProvider,
          name: r'contentTypeTabNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contentTypeTabNotifierHash,
          dependencies: ContentTypeTabNotifierFamily._dependencies,
          allTransitiveDependencies:
              ContentTypeTabNotifierFamily._allTransitiveDependencies,
          type: type,
        );

  ContentTypeTabNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ContentType type;

  @override
  Override overrideWith(
    Stream<List<Content>> Function(ContentTypeTabNotifierRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContentTypeTabNotifierProvider._internal(
        (ref) => create(ref as ContentTypeTabNotifierRef),
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
  AutoDisposeStreamProviderElement<List<Content>> createElement() {
    return _ContentTypeTabNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentTypeTabNotifierProvider && other.type == type;
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
mixin ContentTypeTabNotifierRef on AutoDisposeStreamProviderRef<List<Content>> {
  /// The parameter `type` of this provider.
  ContentType get type;
}

class _ContentTypeTabNotifierProviderElement
    extends AutoDisposeStreamProviderElement<List<Content>>
    with ContentTypeTabNotifierRef {
  _ContentTypeTabNotifierProviderElement(super.provider);

  @override
  ContentType get type => (origin as ContentTypeTabNotifierProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
