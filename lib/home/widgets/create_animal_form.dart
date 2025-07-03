import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/commons/controllers/animal_controller.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateAnimalForm extends StatelessWidget {
  CreateAnimalForm({super.key});

  final AnimalController animalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Cadastrar Animal",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Preencha os dados do animal para cadastro",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Image selection
          Obx(() => InkWell(
                onTap: () => animalController.selectImage(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: animalController.imageSelected.value
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: animalController.imageWidget.value.image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Toque para adicionar uma foto do animal",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "JPG, PNG ou JPEG",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                ),
              )),
          const SizedBox(height: 20),

          // Nome
          TextField(
            decoration: const InputDecoration(
              labelText: "Nome do Animal",
              fillColor: Appcolors.textColor,
              hintText: "Digite o nome do animal",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            controller: animalController.nomeController,
          ),
          const SizedBox(height: 16),

          // Data de Nascimento
          TextField(
            decoration: const InputDecoration(
              labelText: "Data de Nascimento",
              fillColor: Appcolors.textColor,
              hintText: "dd/MM/yyyy",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            inputFormatters: [
              MaskTextInputFormatter(
                mask: "##/##/####",
                filter: {"#": RegExp(r'[0-9]')},
                type: MaskAutoCompletionType.lazy,
              ),
            ],
            controller: animalController.dataNascimentoController,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),

          // Espécie
          TextField(
            decoration: const InputDecoration(
              labelText: "Espécie",
              fillColor: Appcolors.textColor,
              hintText: "Ex: Cão, Gato, etc.",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            controller: animalController.especieController,
          ),
          const SizedBox(height: 16),

          // Raça
          TextField(
            decoration: const InputDecoration(
              labelText: "Raça",
              fillColor: Appcolors.textColor,
              hintText: "Digite a raça do animal",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            controller: animalController.racaController,
          ),
          const SizedBox(height: 16),

          // Porte
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Porte",
              fillColor: Appcolors.textColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(value: "Pequeno", child: Text("Pequeno")),
              DropdownMenuItem(value: "Médio", child: Text("Médio")),
              DropdownMenuItem(value: "Grande", child: Text("Grande")),
            ],
            onChanged: (value) {
              if (value != null) {
                animalController.porteController.text = value;
              }
            },
          ),
          const SizedBox(height: 30),

          // Submit button
          Obx(() => animalController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : FilledButtonWidget(
                  label: "Cadastrar Animal",
                  onPressed: () => animalController.createAnimal(),
                )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
