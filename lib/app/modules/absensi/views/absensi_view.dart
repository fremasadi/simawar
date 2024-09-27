import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/absensi_controller.dart';

class AbsensiView extends GetView<AbsensiController> {
  const AbsensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AbsensiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AbsensiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
