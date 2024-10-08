import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simawar/app/constants/const_color.dart';

class DetailImgView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengambil imgUrl dari arguments
    final String imgUrl = Get.arguments['imgUrl'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColor.backgroundColor,
        title: const Text("Detail Gambar Model"),
      ),
      body: Center(
        child: Image.network(
          imgUrl, // Tampilkan gambar yang diterima
          width: double.infinity,
          height: context.height * .7,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
