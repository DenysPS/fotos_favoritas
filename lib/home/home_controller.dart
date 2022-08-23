import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var methodChannel = MethodChannel('br.com.denysps.fotos_favoritas');
  void getAllPhotos() async {
    final results = await methodChannel.invokeMethod<List>('getPhotos', 1000);
    if (results != null && results.isNotEmpty) {}
  }
}
