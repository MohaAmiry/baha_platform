import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Domain/LoginEntityRequest.dart';
import 'package:baha_platform/Features/_SharedData/LanguagesSwitchButtonWidget.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/AssetsManager.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:baha_platform/utils/SharedOperations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ExceptionHandler/MessageController.dart';
import '../../../ExceptionHandler/MessageEmitter.dart';
import '../../../Router/MyRoutes.gr.dart';
import '../../../utils/Resouces/ValuesManager.dart';
import '../../MarketFeature/ShopFeature/Domain/ShopOverview.dart';
import '../Data/AuthController.dart';
import '../Domain/UserRole.dart';
import '../_CommonWidgets/AuthButton.dart';

@RoutePage()
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController emailTextEdtController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  LoginRequest loginRequest = const LoginRequest(email: "", password: "");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen<AsyncValue<UserRole?>>(authControllerProvider, (previous, next) {
        next.whenData((data) {
          if (data != null) {
            switch (data) {
              case Admin():
                return context.router
                    .replaceAll([const PendingRegisterRequestsRoute()]);
              case Customer():
                return context.router
                    .replaceAll([const AllContentTypesRoute()]);
              case Shop():
                return context.router.replaceAll([
                  SingleShopRoute(shopOverview: ShopOverview.fromShop(data))
                ]);
              case TouristGuide():
                return context.router
                    .replaceAll([const TouristGuideHomeRoute()]);
            }
          }
        });
      })
      ..listen(messageEmitterProvider, (previous, next) {
        next != null
            ? ref
                .read(MessageControllerProvider(context).notifier)
                .showToast(next)
            : null;
      });

    return Scaffold(
      body: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 0.33),
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssetsManager.loginBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(PaddingValuesManager.p20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * .05),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height * .15,
                      child: Image.asset(ImageAssetsManager.logo)),
                  const SizedBox(height: AppSizeManager.s45),
                  Text(
                    context.strings.welcomeToAlBahaGuide,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: ColorManager.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizeManager.s45),
                  TextFormField(
                      controller: emailTextEdtController,
                      onChanged: (value) => setState(() {
                            loginRequest = loginRequest.copyWith(email: value);
                          }),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.email,
                          hintText: context.strings.email)),
                  TextFormField(
                      controller: passwordTextController,
                      obscureText: true,
                      onChanged: (value) => setState(() {
                            loginRequest =
                                loginRequest.copyWith(password: value);
                          }),
                      decoration: InputDecoration(
                          helperText: context.strings.emptyString,
                          labelText: context.strings.password,
                          hintText: context.strings.password)),
                  AuthButton(
                      text: context.strings.login,
                      onPressed: () async {
                        var isVerified = await ref
                            .read(authControllerProvider.notifier)
                            .signIn(loginRequest);
                        if (!isVerified && context.mounted) {
                          showEmailNotVerifiedDialog(context);
                        }
                      }),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: PaddingValuesManager.p10),
                      child: TextButton(
                          onPressed: () async {
                            showResetPasswordDialog(context);
                          },
                          child: Text(context.strings
                              .havingTroubleLoggingInResetYourPassword))),
                  const SizedBox(
                    height: AppSizeManager.s10,
                  ),
                  Text(context.strings.dontHaveAnAccountRegisterHere),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: PaddingValuesManager.p10),
                      child: TextButton(
                          onPressed: () {
                            context.router.push(RegisterRoute(
                                registerType: UserRoleEnum.customer));
                          },
                          child: Text(context.strings.registerAsAUser))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: PaddingValuesManager.p10),
                      child: TextButton(
                          onPressed: () {
                            context.router.push(
                                RegisterRoute(registerType: UserRoleEnum.shop));
                          },
                          child: Text(
                              context.strings.registerAsAServiceProvider))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => context.router
                              .push(const AboutApplicationRoute()),
                          child: Text(context.strings.aboutApplication)),
                      const LanguagesSwitchButtonWidget(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showResetPasswordDialog(BuildContext context) {
    final resetPasswordEmailField = TextEditingController();
    String? error;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizeManager.s5)),
        title: Padding(
          padding: const EdgeInsets.all(PaddingValuesManager.p10),
          child: Text(context.strings.resetPassword),
        ),
        content: TextFormField(
            controller: resetPasswordEmailField,
            decoration: InputDecoration(
                helperText: context.strings.emptyString,
                labelText: context.strings.email,
                hintText: context.strings.email,
                errorText: error)),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (!SharedUserOperations.mailValidator
                  .hasMatch(resetPasswordEmailField.value.text)) {
                setState(() {
                  error = context.strings.exceptionNotEmailForm;
                });
                return;
              }
              if (error != null) {
                setState(() {
                  error = null;
                });
              }
              await ref
                  .read(authControllerProvider.notifier)
                  .sendResetPasswordEmail(resetPasswordEmailField.value.text);
            },
            child: Text(context.strings.sendResetEmail),
          ),
        ],
      ),
    );
  }

  void showEmailNotVerifiedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizeManager.s5)),
        // Rounded corners
        title: Column(children: [
          const Padding(
            padding: EdgeInsets.all(PaddingValuesManager.p10),
            child: Icon(IconsAssetsManager.emailVerificationMessage,
                size: 50, color: ColorManager.primary),
          ),
          Text(context.strings.emailIsNotVerified,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium)
        ]),
        content: Text(
          context.strings.pleaseVerifyYourEmailViaClickingTheSentMessage,
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(authControllerProvider.notifier)
                  .resendVerificationEmail(loginRequest);
            },
            child: Text(context.strings.resendVerificationMessage),
          ),
        ],
      ),
    );
  }
}
