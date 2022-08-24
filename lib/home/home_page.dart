import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/adaptative_image.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Fotos favoritas'),
          actions: [IconButton(onPressed: controller.save, icon: Icon(Icons.save))]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: controller.obx(
            (state) {
              return GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                children: state!.map((e) {
                  return _ImageWidget(
                    onTap: () => controller.togleImage(e.toString()),
                    id: e,
                    size: Get.width * 0.3,
                    selected: controller.isImageSelectd(e.toString()),
                  );
                }).toList(),
              );
            },
            onLoading: const Center(child: CircularProgressIndicator()),
            onEmpty: const Center(child: Text('Nenhuma foto encontrada...')),
            onError: (error) => Center(
              child: Text('Erro: ${error.toString()}'),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.getAllPhotos,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String id;
  final VoidCallback onTap;
  final double size;
  final bool selected;

  const _ImageWidget({
    Key? key,
    required this.onTap,
    required this.id,
    required this.size,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Image(
                key: ValueKey(id),
                fit: BoxFit.cover,
                image: AdaptiveImage(
                  id: id,
                  width: size,
                  height: size,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
