import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            onPressed: () => {Get.toNamed("/login/sign_in")},
            child: const Text("Login"),
          ),
          FilledButton(
            onPressed: () => {Get.toNamed("/login/cadastro")},
            child: const Text("Cadastro"),
          ),
        ],
      ),
    );
  }
}
