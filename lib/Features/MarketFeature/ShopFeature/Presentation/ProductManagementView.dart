import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/Resouces/ValuesManager.dart';
import '../../../../utils/Resouces/theme.dart';
import '../Domain/Product.dart';
import 'Providers/ProductManagementNotifier.dart';

@RoutePage()
class ProductManagementView extends ConsumerStatefulWidget {
  final ProductDTO? productDTO;

  const ProductManagementView({super.key, required this.productDTO});

  @override
  ConsumerState createState() => _ProductManagementViewState();
}

class _ProductManagementViewState extends ConsumerState<ProductManagementView> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  bool updatedImages = false;

  @override
  void initState() {
    super.initState();
    if (widget.productDTO == null) return;
    Future(() {
      nameTextController.text = widget.productDTO!.name.ar;
      descriptionTextController.text = widget.productDTO!.description.ar;
      priceTextController.text = widget.productDTO!.price.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        productManagerNotifierProvider(productDTO: widget.productDTO);
    ref.watch(provider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productDTO == null
            ? context.strings.addProduct
            : context.strings.editProduct),
      ),
      body: Container(
        decoration: ThemeManager.scaffoldBackground,
        child: Padding(
          padding: const EdgeInsets.all(PaddingValuesManager.p20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                    controller: nameTextController,
                    onChanged: (value) =>
                        ref.read(provider.notifier).setName(value),
                    decoration: InputDecoration(
                        helperText: "",
                        labelText: context.strings.productName,
                        hintText: context.strings.productName)),
                TextFormField(
                    controller: descriptionTextController,
                    onChanged: (value) =>
                        ref.read(provider.notifier).setDescription(value),
                    decoration: InputDecoration(
                        helperText: "",
                        labelText: context.strings.productDescription,
                        hintText: context.strings.productDescription)),
                TextFormField(
                    controller: priceTextController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        ref.read(provider.notifier).setPrice(value),
                    decoration: InputDecoration(
                        helperText: "",
                        labelText: context.strings.productPrice,
                        hintText: context.strings.productPrice)),
                if (widget.productDTO != null)
                  CheckboxListTile(
                    value: ref.watch(provider).inStock,
                    onChanged: (value) =>
                        ref.read(provider.notifier).setStock(value!),
                    title: Text(context.strings.stocked),
                  ),
                const Divider(),
                Text(
                  context.strings.images,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(PaddingValuesManager.p10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 300.0,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              enlargeCenterPage: false,
                            ),
                            items: ref.watch(provider).images.map((url) {
                              return widget.productDTO == null || updatedImages
                                  ? Builder(
                                      builder: (BuildContext context) {
                                        return Image.file(
                                          File(url),
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        );
                                      },
                                    )
                                  : Builder(
                                      builder: (BuildContext context) {
                                        return Image.network(
                                          url,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        );
                                      },
                                    );
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var result =
                                  await ref.read(provider.notifier).setImages();
                              if (result) {
                                setState(() {
                                  updatedImages = true;
                                });
                              }
                            },
                            child: Text(context.strings.addImages),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (widget.productDTO == null) {
                        var didAdd =
                            await ref.read(provider.notifier).addProduct();
                        if (didAdd && context.mounted) {
                          context.router.maybePop();
                        }
                        return;
                      }
                      var didEdit = await ref
                          .read(provider.notifier)
                          .updateProduct(updatedImages);
                      if (didEdit && context.mounted) {
                        context.router.maybePop();
                      }
                    },
                    child: Text(context.strings.confirm))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
