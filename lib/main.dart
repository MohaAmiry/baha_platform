import 'package:baha_platform/Localization/LocalizationRepository.dart';
import 'package:baha_platform/utils/Resouces/theme.dart';
import 'package:baha_platform/utils/state_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Features/SplashFeature/Provider/SharedPrefProvider.dart';
import 'Localization/LocalizationProvider.dart';
import 'Router/MyRoutes.dart';
import 'mappableInitializer.init.dart';
//import 'firebase_options.dart';

void initializeFICMappers() {
  // This makes all mappers work with immutable collections
  MapperContainer.globals.useAll([
    // mapper for immutable lists
    SerializableMapper<IList, Object>.arg1(
      decode: IList.fromJson,
      encode: (list) => list.toJson,
      type: <E>(f) => f<IList<E>>(),
    ),
    // mapper for immutable maps
    SerializableMapper<IMap, Map<String, dynamic>>.arg2(
      decode: IMap.fromJson,
      encode: (map) => map.toJson,
      type: <Key, Val>(f) => f<IMap<Key, Val>>(),
    ),
    // mapper for immutable sets
    SerializableMapper<ISet, Object>.arg1(
      decode: ISet.fromJson,
      encode: (set) => set.toJson,
      type: <E>(f) => f<ISet<E>>(),
    ),
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  initializeFICMappers();
  initializeMappers();

  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );

  const bool USE_EMULATOR = false;

  if (USE_EMULATOR) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
  }

  runApp(const ProviderScope(
    child: WarmUp(),
    observers: [StateLogger()],
  ));
}

class WarmUp extends ConsumerStatefulWidget {
  const WarmUp({super.key});

  @override
  ConsumerState createState() => _WarmUpState();
}

class _WarmUpState extends ConsumerState<WarmUp> {
  bool warmedUp = false;

  @override
  Widget build(BuildContext context) {
    if (warmedUp) {
      runApp(const ProviderScope(
        observers: [StateLogger()],
        child: MyApp(),
      ));
    }

    var localRepoState = ref.watch(localizationRepositoryProvider);
    if (localRepoState is! AsyncData) {
      return FittedBox(
        child: Container(color: ColorManager.surface),
      );
    }

    var listenables = <ProviderListenable<AsyncValue<Object?>>>[
      sharedPrefProvider,
      localizationControllerProvider,
    ];

    var states = listenables.map(ref.watch).toList();

    if (states.every((element) => element is AsyncData)) {
      Future(() => setState(() => warmedUp = true));
    }
    return FittedBox(
      child: Container(color: ColorManager.surface),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: ref.watch(availableLanguagesProvider),
        locale: ref.watch(localizationControllerProvider).requireValue,
        debugShowCheckedModeBanner: false,
        title: 'baha_platform',
        theme: ThemeManager.dark(),
        routerConfig: ref.watch(myRoutesProvider));
  }
}
