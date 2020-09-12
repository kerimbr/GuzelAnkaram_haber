import 'package:get_it/get_it.dart';
import 'package:guzelankaram/uvvm_repository/repository.dart';
import 'package:guzelankaram/uvvm_services/api_service.dart';
import 'package:guzelankaram/uvvm_services/shared_preferences_service.dart';
import 'package:guzelankaram/uvvm_viewmodel/view_model.dart';



GetIt locator = GetIt.instance;


void setup(){
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => ViewModel());
  locator.registerLazySingleton(() => SharedPreferencesService());
}