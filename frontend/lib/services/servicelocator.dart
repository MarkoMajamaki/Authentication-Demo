// Service locator instance
import 'package:get_it/get_it.dart';
import 'package:frontend/viewmodels/login_viewmodel.dart';
import 'package:frontend/services/navigation_service.dart';

GetIt serviceLocator = GetIt.instance;

/// Initialize service locator
///
void setupServiceLocator() {
  // Services
  serviceLocator.registerLazySingleton(() => NavigationService());

  // View models
  serviceLocator.registerFactory<LoginViewModel>(() => LoginViewModel());
}
