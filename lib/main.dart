import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Fotos Favoritas',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.homePage,
      getPages: AppPages.routes,
      locale: const Locale('pt', 'BR'),
    ),
  );
}
