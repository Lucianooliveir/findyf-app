import 'package:findyf_app/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: loginController.emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => TextField(
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () => {loginController.visibilidadeSenha()},
                    icon: Icon(
                      loginController.senha.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: loginController.senha.value,
                controller: loginController.senhaController,
              ),
            ),
            FilledButton(
                onPressed: () => {loginController.login()},
                child: const Text("Entrar"))
          ],
        ),
      ),
    );
  }
}
