import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

class HomeController extends GetxController with StateMixin<List<dynamic>> {
  List<String> _selectedImages = [];

  @override
  void onInit() {
    getAllPhotos();
    super.onInit();
  }

  void getAllPhotos() async {
    try {
      change(null, status: RxStatus.loading());
      _loadPrefs();
      final images = await methodChannel.invokeMethod<List>('getPhotos', 1000);
      if (images != null && images.isNotEmpty) {
        change(images, status: RxStatus.success());
      } else {
        change(images, status: RxStatus.empty());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void togleImage(String id) {
    if (_selectedImages.any((element) => element == id)) {
      _selectedImages.removeWhere((element) => element == id);
    } else {
      _selectedImages.add(id);
    }
    update();
  }

  bool isImageSelectd(String id) {
    return _selectedImages.any((element) => element == id);
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoritePrefsKey, _selectedImages);
    Get.snackbar('Concluído!', 'Favoritos salvo com sucesso');
  }

  Future<void> _loadPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedImages = prefs.getStringList(favoritePrefsKey) ?? [];
  }
}
