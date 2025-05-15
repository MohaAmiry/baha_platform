// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContentManagerNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentManagerNotifierHash() =>
    r'2d2fa4215e71915b19edce658a78620290968473';

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

abstract class _$ContentManagerNotifier
    extends BuildlessAutoDisposeNotifier<ContentDTO> {
  late final ContentDTO? contentDTO;

  ContentDTO build({
    ContentDTO? contentDTO,
  });
}

/// See also [ContentManagerNotifier].
@ProviderFor(ContentManagerNotifier)
const contentManagerNotifierProvider = ContentManagerNotifierFamily();

/// See also [ContentManagerNotifier].
class ContentManagerNotifierFamily extends Family<ContentDTO> {
  /// See also [ContentManagerNotifier].
  const ContentManagerNotifierFamily();

  /// See also [ContentManagerNotifier].
  ContentManagerNotifierProvider call({
    ContentDTO? contentDTO,
  }) {
    return ContentManagerNotifierProvider(
      contentDTO: contentDTO,
    );
  }

  @override
  ContentManagerNotifierProvider getProviderOverride(
    covariant ContentManagerNotifierProvider provider,
  ) {
    return call(
      contentDTO: provider.contentDTO,
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
  String? get name => r'contentManagerNotifierProvider';
}

/// See also [ContentManagerNotifier].
class ContentManagerNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ContentManagerNotifier, ContentDTO> {
  /// See also [ContentManagerNotifier].
  ContentManagerNotifierProvider({
    ContentDTO? contentDTO,
  }) : this._internal(
          () => ContentManagerNotifier()..contentDTO = contentDTO,
          from: contentManagerNotifierProvider,
          name: r'contentManagerNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contentManagerNotifierHash,
          dependencies: ContentManagerNotifierFamily._dependencies,
          allTransitiveDependencies:
              ContentManagerNotifierFamily._allTransitiveDependencies,
          contentDTO: contentDTO,
        );

  ContentManagerNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contentDTO,
  }) : super.internal();

  final ContentDTO? contentDTO;

  @override
  ContentDTO runNotifierBuild(
    covariant ContentManagerNotifier notifier,
  ) {
    return notifier.build(
      contentDTO: contentDTO,
    );
  }

  @override
  Override overrideWith(ContentManagerNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ContentManagerNotifierProvider._internal(
        () => create()..contentDTO = contentDTO,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contentDTO: contentDTO,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ContentManagerNotifier, ContentDTO>
      createElement() {
    return _ContentManagerNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentManagerNotifierProvider &&
        other.contentDTO == contentDTO;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contentDTO.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContentManagerNotifierRef on AutoDisposeNotifierProviderRef<ContentDTO> {
  /// The parameter `contentDTO` of this provider.
  ContentDTO? get contentDTO;
}

class _ContentManagerNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ContentManagerNotifier,
        ContentDTO> with ContentManagerNotifierRef {
  _ContentManagerNotifierProviderElement(super.provider);

  @override
  ContentDTO? get contentDTO =>
      (origin as ContentManagerNotifierProvider).contentDTO;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
