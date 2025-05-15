import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Presentation/_Widgets/ProfileImageWidget.dart';
import 'package:baha_platform/Features/_SharedData/ImagePickerNotifier.dart';
import 'package:baha_platform/Features/_SharedData/LocalizedString.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/Resouces/ValuesManager.dart';
import '../../../utils/Resouces/theme.dart';
import '../Data/AuthController.dart';
import '../_CommonWidgets/AuthButton.dart';

@RoutePage()
class RegisterView extends ConsumerStatefulWidget {
  final UserRoleEnum registerType;

  const RegisterView({super.key, required this.registerType});

  @override
  ConsumerState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  UserResponseDTO registerRequest = UserResponseDTO.empty();

  @override
  void initState() {
    super.initState();
    setState(() {
      registerRequest = registerRequest.copyWith(userRole: widget.registerType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: ThemeManager.scaffoldBackground,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(PaddingValuesManager.p20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * .1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: PaddingValuesManager.p20,
                  ),
                  child: Text(context.strings.register,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                const Divider(),
                ProfileImageWidget(
                    profileImageURL: registerRequest.personalImageURL.isEmpty
                        ? null
                        : registerRequest.personalImageURL,
                    managementFunctions: (
                      addFunc: () async {
                        var result = await ref
                            .read(imagePickerNotifierProvider.notifier)
                            .pickProfileImage();
                        setState(() {
                          registerRequest = registerRequest.copyWith(
                              personalImageURL: result?.path ?? "");
                        });
                      },
                      removeFunc: () => setState(() => registerRequest =
                          registerRequest.copyWith(personalImageURL: ""))
                    )),
                const SizedBox(height: AppSizeManager.s20),
                if (widget.registerType == UserRoleEnum.shop)
                  buildServiceProviderTypeWidget(),
                TextFormField(
                    onChanged: (value) {
                      setState(() {
                        registerRequest = registerRequest.copyWith(name: value);
                      });
                    },
                    decoration: InputDecoration(
                        helperText: context.strings.emptyString,
                        labelText: context.strings.name,
                        hintText: context.strings.name)),
                if (widget.registerType == UserRoleEnum.touristGuide ||
                    widget.registerType == UserRoleEnum.shop)
                  TextFormField(
                      onChanged: (value) {
                        setState(() {
                          registerRequest = registerRequest.copyWith(
                              description:
                                  LocalizedString(en: value, ar: value));
                        });
                      },
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.serviceProviderDescription,
                          hintText:
                              context.strings.serviceProviderDescription)),
                TextFormField(
                    onChanged: (value) => setState(() {
                          registerRequest =
                              registerRequest.copyWith(email: value.trim());
                        }),
                    decoration: InputDecoration(
                        helperText: context.strings.emptyString,
                        labelText: context.strings.email,
                        hintText: context.strings.email)),
                TextFormField(
                    onChanged: (value) => setState(() {
                          registerRequest =
                              registerRequest.copyWith(password: value.trim());
                        }),
                    decoration: InputDecoration(
                        helperText: context.strings.emptyString,
                        labelText: context.strings.password,
                        hintText: context.strings.password)),
                TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {
                          registerRequest = registerRequest.copyWith(
                              phoneNumber: value.trim());
                        }),
                    decoration: InputDecoration(
                        helperText: context.strings.emptyString,
                        labelText: context.strings.phoneNumber,
                        hintText: context.strings.phoneNumber)),
                TextFormField(
                    onChanged: (value) => setState(() {
                          registerRequest = registerRequest.copyWith(
                              addressString: value.trim());
                        }),
                    decoration: InputDecoration(
                        helperText: context.strings.emptyString,
                        labelText: context.strings.address,
                        hintText: context.strings.address)),
                TextFormField(
                  onChanged: (value) => setState(() {
                    registerRequest =
                        registerRequest.copyWith(addressURL: value.trim());
                  }),
                  decoration: InputDecoration(
                      helperText: context.strings.emptyString,
                      labelText: context.strings.addressURLOnMap,
                      hintText: context.strings.addressURLOnMap),
                ),
                switch (registerRequest.userRole) {
                  UserRoleEnum.admin => Container(),
                  UserRoleEnum.customer => Container(),
                  UserRoleEnum.shop => buildShopWidget(),
                  UserRoleEnum.touristGuide => buildTouristGuideWidget(),
                },
                if (registerRequest.userRole == UserRoleEnum.shop ||
                    registerRequest.userRole == UserRoleEnum.touristGuide)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: PaddingValuesManager.p20),
                    child: Text(
                      context.strings
                          .registerRequestWillBeSentToAdminForApprovalOrDisapproval,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                AuthButton(
                    text: context.strings.register,
                    onPressed: () async {
                      var result = await ref
                          .read(authControllerProvider.notifier)
                          .signUp(registerRequest
                              .toRegisterRequest(registerRequest.userRole));
                      if (result && context.mounted) context.router.maybePop();
                    }),
                SizedBox(height: MediaQuery.sizeOf(context).height * .1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShopWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.strings.shopType),
          buildShopTypesWidget(),
          const Divider()
        ],
      );

  Widget buildShopTypesWidget() => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: PaddingValuesManager.p20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizeManager.s10)),
        child: DropdownButton(
            hint: Align(
                alignment: Alignment.centerLeft,
                child: Text(context.strings.shopType)),
            isExpanded: true,
            underline: Container(),
            alignment: Alignment.bottomCenter,
            elevation: 0,
            borderRadius: BorderRadius.circular(AppSizeManager.s10),
            value: registerRequest.shopType!,
            icon: const Icon(Icons.keyboard_arrow_down),
            isDense: true,
            menuMaxHeight: MediaQuery.sizeOf(context).height * 0.4,
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingValuesManager.p10,
                vertical: PaddingValuesManager.p10),
            items: [
              DropdownMenuItem(
                  value: ShopTypeEnum.agriculturalShop,
                  child: Text(
                    context.strings.agriculturalShop,
                  )),
              DropdownMenuItem(
                  value: ShopTypeEnum.artisanShop,
                  child: Text(context.strings.artisanShop)),
              DropdownMenuItem(
                  value: ShopTypeEnum.productiveFamilyShop,
                  child: Text(context.strings.productiveFamilyShop)),
            ],
            onChanged: (value) => setState(() =>
                registerRequest = registerRequest.copyWith(shopType: value))),
      );

  Widget buildServiceProviderTypeWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.strings.serviceProviderType),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: PaddingValuesManager.p20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizeManager.s10)),
            child: DropdownButton(
              hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(context.strings.shopType)),
              isExpanded: true,
              underline: Container(),
              alignment: Alignment.bottomCenter,
              elevation: 0,
              borderRadius: BorderRadius.circular(AppSizeManager.s10),
              value: registerRequest.userRole,
              icon: const Icon(Icons.keyboard_arrow_down),
              isDense: true,
              menuMaxHeight: MediaQuery.sizeOf(context).height * 0.4,
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingValuesManager.p10,
                  vertical: PaddingValuesManager.p10),
              items: [
                DropdownMenuItem(
                    value: UserRoleEnum.shop,
                    child: Text(
                      context.strings.shop,
                    )),
                DropdownMenuItem(
                    value: UserRoleEnum.touristGuide,
                    child: Text(context.strings.touristGuide)),
              ],
              onChanged: (value) => setState(() =>
                  registerRequest = registerRequest.copyWith(userRole: value!)),
            ),
          ),
          const Divider()
        ],
      );

  Widget buildTouristGuideWidget() => TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) => setState(() {
          registerRequest =
              registerRequest.copyWith(whatsAppPhoneNumber: value.trim());
        }),
        decoration: InputDecoration(
            helperText: context.strings.emptyString,
            labelText: context.strings.whatsAppPhoneNumber,
            hintText: context.strings.whatsAppPhoneNumber),
      );
}
