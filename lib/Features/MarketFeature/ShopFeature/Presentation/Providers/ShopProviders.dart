import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../Domain/Product.dart';
import '../../Domain/ShopOverview.dart';

part 'ShopProviders.g.dart';

@riverpod
Stream<IList<Product>> shopAllProducts(Ref ref, ShopOverview shopOverview) {
  return ref
      .read(repositoryClientProvider)
      .shopRepository
      .getShopProducts(shopOverview);
}

@riverpod
Stream<List<Product>> productsByType(Ref ref, ShopTypeEnum type) {
  return ref
      .read(repositoryClientProvider)
      .productsRepository
      .getProductsByShopTypeStream(type);
}

@riverpod
Stream<List<ShopOverview>> shopsOverviewByType(Ref ref, ShopTypeEnum type) {
  return ref
      .read(repositoryClientProvider)
      .shopRepository
      .getShopsOverviews(shopType: type);
}

@riverpod
Stream<UserResponseDTO> shopInformationById(Ref ref, String userId) {
  return ref
      .read(repositoryClientProvider)
      .authRepository
      .getUserInfoByIdStream(userId);
}
