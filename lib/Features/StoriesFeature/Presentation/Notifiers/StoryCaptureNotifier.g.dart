// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StoryCaptureNotifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyCaptureNotifierHash() =>
    r'157b8d64c880612c5247054665653c165ed73477';

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

abstract class _$StoryCaptureNotifier
    extends BuildlessAutoDisposeAsyncNotifier<StoryCaptureModel> {
  late final XFile? preSelection;

  FutureOr<StoryCaptureModel> build({
    XFile? preSelection,
  });
}

/// See also [StoryCaptureNotifier].
@ProviderFor(StoryCaptureNotifier)
const storyCaptureNotifierProvider = StoryCaptureNotifierFamily();

/// See also [StoryCaptureNotifier].
class StoryCaptureNotifierFamily extends Family<AsyncValue<StoryCaptureModel>> {
  /// See also [StoryCaptureNotifier].
  const StoryCaptureNotifierFamily();

  /// See also [StoryCaptureNotifier].
  StoryCaptureNotifierProvider call({
    XFile? preSelection,
  }) {
    return StoryCaptureNotifierProvider(
      preSelection: preSelection,
    );
  }

  @override
  StoryCaptureNotifierProvider getProviderOverride(
    covariant StoryCaptureNotifierProvider provider,
  ) {
    return call(
      preSelection: provider.preSelection,
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
  String? get name => r'storyCaptureNotifierProvider';
}

/// See also [StoryCaptureNotifier].
class StoryCaptureNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    StoryCaptureNotifier, StoryCaptureModel> {
  /// See also [StoryCaptureNotifier].
  StoryCaptureNotifierProvider({
    XFile? preSelection,
  }) : this._internal(
          () => StoryCaptureNotifier()..preSelection = preSelection,
          from: storyCaptureNotifierProvider,
          name: r'storyCaptureNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyCaptureNotifierHash,
          dependencies: StoryCaptureNotifierFamily._dependencies,
          allTransitiveDependencies:
              StoryCaptureNotifierFamily._allTransitiveDependencies,
          preSelection: preSelection,
        );

  StoryCaptureNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.preSelection,
  }) : super.internal();

  final XFile? preSelection;

  @override
  FutureOr<StoryCaptureModel> runNotifierBuild(
    covariant StoryCaptureNotifier notifier,
  ) {
    return notifier.build(
      preSelection: preSelection,
    );
  }

  @override
  Override overrideWith(StoryCaptureNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StoryCaptureNotifierProvider._internal(
        () => create()..preSelection = preSelection,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        preSelection: preSelection,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<StoryCaptureNotifier,
      StoryCaptureModel> createElement() {
    return _StoryCaptureNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryCaptureNotifierProvider &&
        other.preSelection == preSelection;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, preSelection.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StoryCaptureNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<StoryCaptureModel> {
  /// The parameter `preSelection` of this provider.
  XFile? get preSelection;
}

class _StoryCaptureNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StoryCaptureNotifier,
        StoryCaptureModel> with StoryCaptureNotifierRef {
  _StoryCaptureNotifierProviderElement(super.provider);

  @override
  XFile? get preSelection =>
      (origin as StoryCaptureNotifierProvider).preSelection;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
