import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
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
      appBar: AppBar(title: const Text("Entrar")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Email",
                fillColor: Appcolors.textColor,
                hintText: "exemplo@email.com",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
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
                  fillColor: Appcolors.textColor,
                  hintText: "**********",
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
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
            const Spacer(),
            FilledButtonWidget(
              onPressed: () => {loginController.login()},
              label: "Entrar",
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
