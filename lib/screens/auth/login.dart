import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/screens/auth/join.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends GetWidget<AuthController> {
  Login({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo2.png",
              width: 500,
              height: 250,
            ),
            // SizedBox(height: _height * 0.04),
            getInputTextField("아이디", controller.userIdTextController),
            SizedBox(height: _height * 0.0075),
            getInputTextField("비밀번호", controller.passwordTextController),
            SizedBox(height: _height * 0.022),
            GestureDetector(
              onTap: () => Get.to(Join()),
              child: Text("처음이신가요? 회원가입", style: loginPageMealPlanner),
            ),
            SizedBox(height: _height * 0.145),
            Obx(() {
              bool isEmpty = controller.isTextFieldsEmpty['username'] || controller.isTextFieldsEmpty['password'];

              return GestureDetector(
                onTap: () => {controller.logInWithDimigoinAccount()},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _width * 0.858,
                  height: _height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: dalgeurakBlueOne,
                    ),
                    color: isEmpty ? Colors.white : dalgeurakBlueOne,
                  ),
                  child: Center(child: Text("로그인", style: isEmpty ? btnTitle1 : btnTitle1.copyWith(color: Colors.white))),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  SizedBox getInputTextField(String hintText, TextEditingController textController) {
    String engTextFieldType = hintText.contains("아이디") ? "username" : "password";

    return SizedBox(
      width: 330,
      child: TextField(
        keyboardType: TextInputType.text,
        controller: textController,
        textAlign: TextAlign.center,
        style: loginTextFieldText,
        obscureText: hintText.contains("비밀번호"),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: _height * 0.02),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 0, style: BorderStyle.none,)),
          fillColor: dalgeurakGrayOne,
          filled: true,
          hintText: hintText,
          hintStyle: loginTextFieldHintText,
        ),
        onChanged: (value) => controller.isTextFieldsEmpty[engTextFieldType] = value.isEmpty,
      ),
    );
  }
}
