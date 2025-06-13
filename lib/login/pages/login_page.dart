import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "assets/images/logo.png",
            ),
            const Spacer(),
            FilledButtonWidget(
              label: "Entrar",
              onPressed: () => {Get.toNamed("/login/sign_in")},
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButtonWidget(
              label: "Cadastrar-se",
              onPressed: () => {Get.toNamed("/login/cadastro")},
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
