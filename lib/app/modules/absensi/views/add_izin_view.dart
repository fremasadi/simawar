import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddIzinView extends GetView {
  const AddIzinView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddIzinView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddIzinView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
