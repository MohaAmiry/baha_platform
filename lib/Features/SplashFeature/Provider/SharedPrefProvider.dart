import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'SharedPrefProvider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPref(SharedPrefRef ref) async {
  return SharedPreferences.getInstance();
}

@riverpod
Future<bool> firstTime(FirstTimeRef ref) async {
  //ref.read(sharedPrefProvider).requireValue.remove("firstTime");
  var doesExist =
      ref.read(sharedPrefProvider).requireValue.containsKey("firstTime");
  if (!doesExist) {
    ref.read(sharedPrefProvider).requireValue.setBool("firstTime", true);
  }
  return ref.watch(sharedPrefProvider).requireValue.getBool("firstTime")!;
}
