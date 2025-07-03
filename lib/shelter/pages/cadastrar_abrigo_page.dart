import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:findyf_app/shelter/controllers/shelter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastrarAbrigoPage extends StatelessWidget {
  CadastrarAbrigoPage({super.key});

  final ShelterController shelterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tornar-se Abrigo"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Cadastro de Abrigo",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Preencha os dados para se tornar um abrigo",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            // Nome do Responsável
            TextField(
              decoration: const InputDecoration(
                labelText: "Nome do Responsável",
                fillColor: Appcolors.textColor,
                hintText: "Digite o nome completo",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              controller: shelterController.nomeResponsavelController,
            ),
            const SizedBox(height: 20),

            // CRMV
            TextField(
              decoration: const InputDecoration(
                labelText: "CRMV",
                fillColor: Appcolors.textColor,
                hintText: "Digite o número do CRMV",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
              controller: shelterController.crmvController,
            ),
            const SizedBox(height: 20),

            // Telefone
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
              controller: shelterController.telefoneController,
              keyboardType: TextInputType.phone,
            ),

            const Spacer(),

            // Submit Button
            Obx(() => shelterController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : FilledButtonWidget(
                    label: "Cadastrar Abrigo",
                    onPressed: () => shelterController.cadastrarAbrigo(),
                  )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
