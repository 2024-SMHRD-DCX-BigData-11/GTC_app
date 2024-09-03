import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/screens/widgets/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Join extends GetWidget<AuthController> {
  Join({Key? key}) : super(key: key);

  late double _height, _width;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordContorller = TextEditingController();
  final TextEditingController _confirmPasswordContorller = TextEditingController();

  final Rx<DimigoinUserType> _userType = DimigoinUserType.student.obs; // 기본값은 "학생"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "아이디를 입력하세요";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "아이디",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "이름을 입력하세요";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "이름",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "전화번호를 입력하세요";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "전화번호",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // 라디오 버튼 추가
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "사용자 유형",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Obx(() {
                            return Row(
                              children: [
                                Radio<DimigoinUserType>(
                                  value: DimigoinUserType.student,
                                  groupValue: _userType.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      _userType.value = value;
                                    }
                                  },
                                ),
                                const Text("학생"),
                                Radio<DimigoinUserType>(
                                  value: DimigoinUserType.teacher,
                                  groupValue: _userType.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      _userType.value = value;
                                    }
                                  },
                                ),
                                const Text("선생"),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _passwordContorller,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "비밀번호를 입력하세요";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "비밀번호",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _confirmPasswordContorller,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "비밀번호를 입력하세요";
                          } else if (value != _passwordContorller.text) {
                            return "비밀번호가 일치하지 않습니다.";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "비밀번호 확인",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, process data
                            String username = _usernameController.text;
                            String password = _passwordContorller.text;
                            String confirmPassword = _confirmPasswordContorller
                                .text;
                            String name = _nameController.text;
                            String phone = _phoneController.text;

                            if (password != confirmPassword) {
                              controller.showToast("비밀번호가 일치하지 않습니다.");
                              return;
                            }
                            controller.join(
                              username,
                              password,
                              name,
                              phone,
                              _userType.value == DimigoinUserType.teacher,
                              //_userType // 사용자 유형 전달
                            );
                          }
                        },
                        child: const CustumButton(
                          buttonName: "회원가입",
                          buttonColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Flutter의 StatefulWidget과 같이 setState를 사용하기 위해 setState 메서드를 추가합니다.
  void setState(VoidCallback fn) {
    fn();
  }
}
