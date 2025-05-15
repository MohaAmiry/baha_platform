import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Data/AuthController.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserResponseDTO.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/UserRole.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Presentation/Notifiers/ProfileNotifier.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/Resouces/ValuesManager.dart';
import '../../../utils/Resouces/theme.dart';
import '../../_SharedData/LocalizedString.dart';

@RoutePage()
class EditProfileView extends ConsumerStatefulWidget {
  final UserResponseDTO userResponseDTO;

  const EditProfileView({super.key, required this.userResponseDTO});

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressURLController = TextEditingController();
  final TextEditingController additionalPhoneController =
      TextEditingController();
  final TextEditingController serviceProviderDescriptionController =
      TextEditingController();
  UserResponseDTO userResponseDTO = UserResponseDTO.empty();

  @override
  void initState() {
    super.initState();

    Future(() {
      setState(() {
        userResponseDTO = widget.userResponseDTO;
        nameController.text = widget.userResponseDTO.name;
        phoneController.text = widget.userResponseDTO.phoneNumber;
        addressController.text = widget.userResponseDTO.addressString;
        addressURLController.text = widget.userResponseDTO.addressURL ?? "";
        additionalPhoneController.text =
            widget.userResponseDTO.whatsAppPhoneNumber ?? "";
        serviceProviderDescriptionController.text =
            widget.userResponseDTO.description?.ar ?? "";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    addressURLController.dispose();
    additionalPhoneController.dispose();
    serviceProviderDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isServiceProvider =
        ref.watch(authControllerProvider).requireValue.runtimeType == Shop ||
            ref.watch(authControllerProvider).requireValue.runtimeType ==
                TouristGuide;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
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
                  child: Text(context.strings.updateUserInformation,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: AppSizeManager.s20),
                TextFormField(
                  controller: nameController,
                  enabled: !isServiceProvider,
                  onChanged: (value) =>
                      userResponseDTO = userResponseDTO.copyWith(name: value),
                  decoration: InputDecoration(
                      helperText: context.strings.emptyString,
                      labelText: context.strings.name,
                      hintText: context.strings.name),
                ),
                if (widget.userResponseDTO.userRole ==
                        UserRoleEnum.touristGuide ||
                    widget.userResponseDTO.userRole == UserRoleEnum.shop)
                  TextFormField(
                      controller: serviceProviderDescriptionController,
                      onChanged: (value) {
                        setState(() {
                          userResponseDTO = userResponseDTO.copyWith(
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
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => userResponseDTO =
                      userResponseDTO.copyWith(phoneNumber: value),
                  enabled: !isServiceProvider,
                  decoration: InputDecoration(
                      helperText: context.strings.emptyString,
                      labelText: context.strings.phoneNumber,
                      hintText: context.strings.phoneNumber),
                ),
                TextFormField(
                  controller: addressController,
                  onChanged: (value) => userResponseDTO =
                      userResponseDTO.copyWith(addressString: value),
                  enabled: !isServiceProvider,
                  decoration: InputDecoration(
                      helperText: context.strings.emptyString,
                      labelText: context.strings.address,
                      hintText: context.strings.address),
                ),
                TextFormField(
                  controller: addressURLController,
                  onChanged: (value) => setState(() {
                    userResponseDTO =
                        userResponseDTO.copyWith(addressURL: value.trim());
                  }),
                  enabled: !isServiceProvider,
                  decoration: InputDecoration(
                      helperText: context.strings.emptyString,
                      labelText: context.strings.addressURLOnMap,
                      hintText: context.strings.addressURLOnMap),
                ),
                if (widget.userResponseDTO.userRole ==
                    UserRoleEnum.touristGuide)
                  TextFormField(
                    controller: additionalPhoneController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => userResponseDTO =
                        userResponseDTO.copyWith(whatsAppPhoneNumber: value),
                    enabled: !isServiceProvider,
                    decoration: InputDecoration(
                        helperText: context.strings.emptyString,
                        labelText: context.strings.whatsAppPhoneNumber,
                        hintText: context.strings.whatsAppPhoneNumber),
                  ),
                ElevatedButton(
                    onPressed: () async {
                      var result = await ref
                          .read(profileNotifierProvider.notifier)
                          .updateUserInfo(userResponseDTO);
                      if (result && context.mounted) {
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
