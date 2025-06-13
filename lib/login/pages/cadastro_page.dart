import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:findyf_app/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// ignore: must_be_immutable
class CadastroPage extends StatelessWidget {
  CadastroPage({super.key});
  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            TextField(
              decoration: const InputDecoration(
                labelText: "Telefone",
                fillColor: Appcolors.textColor,
                hintText: "(12) 34567-8901",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: "(##) #####-####",
                  filter: {"#": RegExp(r'[0-9]')},
                  type: MaskAutoCompletionType.lazy,
                ),
              ],
              controller: loginController.telefoneController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => TextField(
                decoration: InputDecoration(
                  labelText: "Senha",
                  fillColor: Appcolors.textColor,
                  hintText: "********",
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Cep",
                      fillColor: Appcolors.textColor,
                      hintText: "12345-678",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    controller: loginController.cepController,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: "#####-###",
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const Spacer(),
            FilledButtonWidget(
              onPressed: () => {
                loginController.concluirCadastro(),
              },
              label: "Continuar",
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
