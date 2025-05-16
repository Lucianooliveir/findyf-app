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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                controller: loginController.nomeController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  border: OutlineInputBorder(),
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
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Cep",
                        border: OutlineInputBorder(),
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Número",
                        border: OutlineInputBorder(),
                      ),
                      controller: loginController.numeroController,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () => {
                  loginController.concluirCadastro(),
                },
                child: const Text("Concluir cadastro"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
