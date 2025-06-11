import 'package:get_it/get_it.dart';
import 'package:order_tracker_app/core/utils/storage_helper.dart';
import 'package:order_tracker_app/features/auth/data/repo/auth_repo.dart';
import 'package:order_tracker_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  //Storage Helper

  sl.registerLazySingleton(() => StorageHelper());

  // Repos
  sl.registerSingleton<AuthRepo>(AuthRepo());

  // Cubit
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
}
