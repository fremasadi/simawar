// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simawar/app/constants/const_color.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: 'AIzaSyB0pNPcc8O0-XduVSFT1PFskx_C6Aedfh8',
  //     appId: '1:580500823984:android:d907a1f8a63839eb490075',
  //     projectId: 'simawar-32ffb',
  //     messagingSenderId: '',
  //     storageBucket: 'gs://simawar-32ffb.appspot.com',
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
                data: data.copyWith(
                  textScaler: const TextScaler.linear(1.10),
                ),
                child: child!);
          },
          theme: ThemeData(
            scaffoldBackgroundColor: ConstColor.backgroundColor,
            fontFamily: 'Poppins',
          ),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
