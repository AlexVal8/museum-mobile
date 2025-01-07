import 'package:get_it/get_it.dart';
import 'package:museum/controllers/token_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<TokenService>(TokenService());
  // getIt.registerLazySingleton<TokenService>(() => TokenService());
}