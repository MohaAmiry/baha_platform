import 'package:auto_route/auto_route.dart';
import 'package:baha_platform/Features/AuthenticationFeature/Presentation/Notifiers/PendingRegisterRequestsProvider.dart';
import 'package:baha_platform/Features/SplashFeature/ErrorView.dart';
import 'package:baha_platform/Features/SplashFeature/LoadingView.dart';
import 'package:baha_platform/utils/Extensions.dart';
import 'package:baha_platform/utils/Resouces/ValuesManager.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ExceptionHandler/MessageController.dart';
import '../../../ExceptionHandler/MessageEmitter.dart';
import '../../../Router/MyRoutes.gr.dart';
import '../../_SharedData/AbstractDrawer.dart';
import '../Data/AuthController.dart';
import '../Domain/UserRole.dart';
import '_Widgets/PendingRegisterRequestWidget.dart';

@RoutePage()
class PendingRegisterRequestsView extends ConsumerWidget {
  const PendingRegisterRequestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen<AsyncValue<UserRole?>>(authControllerProvider, (previous, next) {
        next.whenData((data) {
          if (data == null) {
            return context.router.replaceAll([const LoginRoute()]);
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
      appBar: AppBar(
        title: Text(context.strings.registerRequests),
      ),
      drawer: const AbstractDrawer(userRoleEnum: UserRoleEnum.admin),
      body: Container(
        decoration: ThemeManager.scaffoldBackground,
        child: ref.watch(pendingRegisterRequestsNotifierProvider).when(
            data: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(PaddingValuesManager.p10),
                    child: PendingRegisterRequestWidget(
                        userResponseDTO: data.elementAt(index)),
                  ),
                ),
            error: (error, stackTrace) => ErrorView(error: error),
            loading: () => const LoadingView()),
      ),
    );
  }
}
