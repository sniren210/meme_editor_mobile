import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:meme_editor_mobile/core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final memeEditBox = await Hive.openBox<String>('meme_edits');

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => memeEditBox);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));

}
