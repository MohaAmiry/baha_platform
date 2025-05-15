import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/_SharedData/AbstractDataRepository.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/Localization/LocalizationProvider.dart';
import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../ExceptionHandler/MessageEmitter.dart';
import '../../../../../utils/SharedOperations.dart';
import '../../../../_SharedData/ImagePickerNotifier.dart';
import '../../Domain/Product.dart';

part 'ProductManagementNotifier.g.dart';

@riverpod
class ProductManagerNotifier extends _$ProductManagerNotifier
    with SharedUserOperations {
  @override
  ProductDTO build({ProductDTO? productDTO}) {
    return productDTO ??
        ProductDTO.withShopOverview(
            ref.read(authControllerProvider).requireValue!.user!.uid);
  }

  void setName(String name) {
    state = state.copyWith(name: LocalizedString(en: name, ar: name));
  }

  void setDescription(String description) => state = state.copyWith(
      description: LocalizedString(en: description, ar: description));

  void setPrice(String price) {
    state = state.copyWith(price: double.tryParse(price) ?? -1);
  }

  void setStock(bool stock) => state = state.copyWith(inStock: stock);

  Future<bool> setImages() async {
    var result = await AsyncValue.guard(
        () => ref.read(imagePickerNotifierProvider.notifier).pickImages());
    if (result.hasError) {
      ref.read(messageEmitterProvider.notifier).setFailed(
          message: Exception(result.error.toString()),
          stackTrace: StackTrace.empty);
      return false;
    }
    state = state.copyWith(images: result.requireValue.toList());
    return true;
  }

  Future<bool> addProduct() async {
    var result = await ref.operationPipeLine(func: () async {
      validateProduct();
      await translateProduct();
      return ref
          .read(repositoryClientProvider)
          .productsRepository
          .addProduct(state);
    });

    if (result.hasError) return false;
    return true;
  }

  Future<bool> removeProduct(String productId) async {
    var result = await ref.operationPipeLine(
        func: () => ref
            .read(repositoryClientProvider)
            .productsRepository
            .removeProduct(productId));
    if (result.hasError) return false;
    return true;
  }

  Future<bool> updateProduct(bool changedImages) async {
    var result = await ref.operationPipeLine(func: () {
      validateProduct();
      translateProduct();
      return ref
          .read(repositoryClientProvider)
          .productsRepository
          .updateProduct(changedImages ? state : state.copyWith(images: []));
    });
    if (result.hasError) {
      return false;
    }
    return true;
  }

  Future<void> translateProduct() async {
    state = state.copyWith(
        name: await ref
            .read(localizationRepositoryProvider)
            .requireValue
            .localizeString(state.name),
        description: await ref
            .read(localizationRepositoryProvider)
            .requireValue
            .localizeString(state.description));
  }

  void validateProduct() {
    if (state.name.ar.isEmpty) {
      throw Exception(
          ref.read(localizationProvider).exceptionProductNameCantBeEmpty);
    }
    if (state.price < 1) {
      throw Exception(ref.read(localizationProvider).exceptionNotValidPrice);
    }
    if (state.images.isEmpty) {
      throw Exception(ref.read(localizationProvider).exceptionAddAtLeast1Image);
    }
  }
}
