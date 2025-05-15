// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageController.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageControllerHash() => r'4dba43b1d40d4a2a5ccfe1d5d2e47c2b2dcbbe95';

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

abstract class _$MessageController extends BuildlessAutoDisposeNotifier<void> {
  late final BuildContext context;

  void build(
    BuildContext context,
  );
}

/// See also [MessageController].
@ProviderFor(MessageController)
const messageControllerProvider = MessageControllerFamily();

/// See also [MessageController].
class MessageControllerFamily extends Family<void> {
  /// See also [MessageController].
  const MessageControllerFamily();

  /// See also [MessageController].
  MessageControllerProvider call(
    BuildContext context,
  ) {
    return MessageControllerProvider(
      context,
    );
  }

  @override
  MessageControllerProvider getProviderOverride(
    covariant MessageControllerProvider provider,
  ) {
    return call(
      provider.context,
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
  String? get name => r'messageControllerProvider';
}

/// See also [MessageController].
class MessageControllerProvider
    extends AutoDisposeNotifierProviderImpl<MessageController, void> {
  /// See also [MessageController].
  MessageControllerProvider(
    BuildContext context,
  ) : this._internal(
          () => MessageController()..context = context,
          from: messageControllerProvider,
          name: r'messageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageControllerHash,
          dependencies: MessageControllerFamily._dependencies,
          allTransitiveDependencies:
              MessageControllerFamily._allTransitiveDependencies,
          context: context,
        );

  MessageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
  }) : super.internal();

  final BuildContext context;

  @override
  void runNotifierBuild(
    covariant MessageController notifier,
  ) {
    return notifier.build(
      context,
    );
  }

  @override
  Override overrideWith(MessageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessageControllerProvider._internal(
        () => create()..context = context,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MessageController, void> createElement() {
    return _MessageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageControllerProvider && other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessageControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _MessageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<MessageController, void>
    with MessageControllerRef {
  _MessageControllerProviderElement(super.provider);

  @override
  BuildContext get context => (origin as MessageControllerProvider).context;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
