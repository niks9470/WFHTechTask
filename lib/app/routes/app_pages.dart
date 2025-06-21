import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/detailsScreen/bindings/details_screen_binding.dart';
import '../modules/detailsScreen/views/details_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETAILS_SCREEN,
      page: () =>  DetailsScreenView(),
      binding: DetailsScreenBinding(),
    ),
  ];
}
