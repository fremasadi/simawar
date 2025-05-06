import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailImgView extends StatelessWidget {
  const DetailImgView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final List images = args['images'];
    final int initialIndex = args['initialIndex'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Gambar')),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Image.network(
              images[index],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          );
        },
      ),
    );
  }
}
