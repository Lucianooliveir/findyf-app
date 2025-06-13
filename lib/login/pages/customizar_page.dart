import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:findyf_app/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class CustomizarPage extends StatelessWidget {
  CustomizarPage({super.key});

  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customizar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Personalize seu perfil",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Center(
              child: Text(
                "Clique abaixo para mudar sua imagem de perfil",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => InkWell(
                onTap: () => {loginController.escolherImagem()},
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundImage: loginController.file.value.image,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FilledButtonWidget(
                  label: "Redefinir",
                  onPressed: () => {loginController.redefinir()}),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text("Nome"),
            ),
            Center(
              child: TextField(
                decoration: const InputDecoration(
                  // labelText: "Nome",
                  fillColor: Appcolors.textColor,
                  hintText: "Nome Sobrenome",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                controller: loginController.nomeController,
              ),
            ),
            const Spacer(),
            FilledButtonWidget(
                label: "Concluir cadastro",
                onPressed: () => {loginController.enviarCadastro()}),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
