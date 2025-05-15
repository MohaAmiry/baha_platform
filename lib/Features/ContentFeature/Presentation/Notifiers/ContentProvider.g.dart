// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContentProvider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getContentByIdHash() => r'703d19fad22ef85d52a946da3c6614a108daafb7';

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

/// See also [getContentById].
@ProviderFor(getContentById)
const getContentByIdProvider = GetContentByIdFamily();

/// See also [getContentById].
class GetContentByIdFamily extends Family<AsyncValue<Content>> {
  /// See also [getContentById].
  const GetContentByIdFamily();

  /// See also [getContentById].
  GetContentByIdProvider call(
    String contentId,
  ) {
    return GetContentByIdProvider(
      contentId,
    );
  }

  @override
  GetContentByIdProvider getProviderOverride(
    covariant GetContentByIdProvider provider,
  ) {
    return call(
      provider.contentId,
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
  String? get name => r'getContentByIdProvider';
}

/// See also [getContentById].
class GetContentByIdProvider extends AutoDisposeStreamProvider<Content> {
  /// See also [getContentById].
  GetContentByIdProvider(
    String contentId,
  ) : this._internal(
          (ref) => getContentById(
            ref as GetContentByIdRef,
            contentId,
          ),
          from: getContentByIdProvider,
          name: r'getContentByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getContentByIdHash,
          dependencies: GetContentByIdFamily._dependencies,
          allTransitiveDependencies:
              GetContentByIdFamily._allTransitiveDependencies,
          contentId: contentId,
        );

  GetContentByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contentId,
  }) : super.internal();

  final String contentId;

  @override
  Override overrideWith(
    Stream<Content> Function(GetContentByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetContentByIdProvider._internal(
        (ref) => create(ref as GetContentByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contentId: contentId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Content> createElement() {
    return _GetContentByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetContentByIdProvider && other.contentId == contentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetContentByIdRef on AutoDisposeStreamProviderRef<Content> {
  /// The parameter `contentId` of this provider.
  String get contentId;
}

class _GetContentByIdProviderElement
    extends AutoDisposeStreamProviderElement<Content> with GetContentByIdRef {
  _GetContentByIdProviderElement(super.provider);

  @override
  String get contentId => (origin as GetContentByIdProvider).contentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
