import 'package:get/get.dart';

import '../home/home_page.dart';

class AppPages {
  static const homePage = '/';
  static const photoPage = '/PhotoPage';

  static final routes = [
    GetPage(
      name: homePage,
      page: () => const HomePage(),
      //binding: HomeBindings(),
    ),

    // GetPage(
    //   name: photoPage,
    //   page: () => const PhotoPage(),
    //   binding: PhotoBindings(),
    // ),
  ];
}
