// lib/app/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/const_color.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .1,
              horizontal: 16.sp),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/img_logo.png',
                    height: 150.h,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0.sp),
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ConstColor.secondaryColor,
                    ),
                  ),
                ),
                Text(
                  'Karyawan Login!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ConstColor.black,
                  ),
                ),
                SizedBox(height: 20.h), // Add some spacing
                _buildEmailField(),
                SizedBox(height: 20.h), // Add some spacing
                _buildPasswordField(),
                SizedBox(height: 40.h), // Add some spacing
                _buildLoginButton(),
                SizedBox(height: 20.h), // Add some spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ConstColor.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ConstColor.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ConstColor.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.sp),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silakan masukkan email Anda';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Silakan masukkan email yang valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: controller.passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ConstColor.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ConstColor.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ConstColor.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(12.sp),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silakan masukkan kata sandi Anda';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.login, // langsung panggil login
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
            backgroundColor: ConstColor.primaryColor,
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: ConstColor.white)
              : Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ConstColor.white,
                  ),
                ),
        ));
  }
}
