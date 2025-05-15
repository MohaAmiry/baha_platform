import 'package:baha_platform/Features/ContentFeature/Data/CommentsRepository.dart';
import 'package:baha_platform/Features/ContentFeature/Data/ContentRepository.dart';
import 'package:baha_platform/Features/StoriesFeature/Data/StoriesRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../AuthenticationFeature/Data/AuthRepository.dart';
import '../MarketFeature/CartFeature/Data/CartRepository.dart';
import '../MarketFeature/CartFeature/Data/OrdersRepository.dart';
import '../MarketFeature/ShopFeature/Data/DealerRepository.dart';
import '../MarketFeature/ShopFeature/Data/ProductRepository.dart';

part 'AbstractDataRepository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref);
}

@Riverpod(keepAlive: true)
ProductsRepository productsRepository(Ref ref) {
  return ProductsRepository(ref: ref);
}

@Riverpod(keepAlive: true)
ShopRepository shopRepository(Ref ref) {
  return ShopRepository(ref: ref);
}

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) {
  return CartRepository(ref: ref);
}

@Riverpod(keepAlive: true)
OrdersRepository ordersRepository(Ref ref) {
  return OrdersRepository(ref: ref);
}

@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) {
  return ContentRepository(ref, CommentsRepository(ref));
}

@Riverpod(keepAlive: true)
StoriesRepository storiesRepository(Ref ref) {
  return StoriesRepository(ref);
}

@Riverpod(keepAlive: true)
_RepositoryClient repositoryClient(Ref ref) {
  return _RepositoryClient(
      storiesRepository: ref.read(storiesRepositoryProvider),
      contentRepository: ref.read(contentRepositoryProvider),
      authRepository: ref.read(authRepositoryProvider),
      shopRepository: ref.read(shopRepositoryProvider),
      productsRepository: ref.read(productsRepositoryProvider),
      cartRepository: ref.read(cartRepositoryProvider),
      ordersRepository: ref.read(ordersRepositoryProvider));
}

abstract class AbstractRepository {
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
}

class _RepositoryClient {
  final AuthRepository authRepository;
  final ShopRepository shopRepository;
  final ProductsRepository productsRepository;
  final CartRepository cartRepository;
  final OrdersRepository ordersRepository;
  final ContentRepository contentRepository;
  final StoriesRepository storiesRepository;

  const _RepositoryClient(
      {required this.productsRepository,
      required this.storiesRepository,
      required this.contentRepository,
      required this.shopRepository,
      required this.authRepository,
      required this.cartRepository,
      required this.ordersRepository});
}
