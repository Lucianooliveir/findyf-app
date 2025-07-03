import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/commons/controllers/animal_controller.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:findyf_app/home/widgets/create_animal_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class CreatePage extends StatelessWidget {
  CreatePage({super.key});
  final HomeController homeController = Get.find();
  final GlobalController globalController = Get.find();
  final AnimalController animalController = Get.put(AnimalController());

  @override
  Widget build(BuildContext context) {
    final Rx<int> selectedAnimalId = 0.obs;
    return Obx(() {
      final user = globalController.userInfos.value;

      // If user is not a shelter, show only the regular post creation
      if (user == null || !user.isShelter) {
        return _buildRegularPostForm();
      }

      // If user is a shelter, fetch animals for dropdown
      if (user.abrigo != null && animalController.shelterAnimals.isEmpty) {
        animalController.getAnimaisByUserId(user.abrigo!.id);
      }

      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Appcolors.primaryColor,
              indicatorColor: Appcolors.primaryColor,
              tabs: [
                Tab(
                  icon: Icon(Icons.post_add),
                  text: "Criar Post",
                ),
                Tab(
                  icon: Icon(Icons.pets),
                  text: "Cadastrar Animal",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRegularPostForm(
                      isShelter: true, selectedAnimalId: selectedAnimalId),
                  CreateAnimalForm(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRegularPostForm(
      {bool isShelter = false, Rx<int>? selectedAnimalId}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Obx(
            () => InkWell(
              onTap: () => homeController.escolherImagem(),
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: homeController.trocou.value
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: homeController.file.value.image,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Toque para adicionar uma imagem",
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
            ),
          ),
          const SizedBox(height: 30),
          if (isShelter && selectedAnimalId != null)
            Obx(() {
              final animals = animalController.shelterAnimals;
              if (animals.isEmpty) {
                return const SizedBox();
              }
              return DropdownButtonFormField<int>(
                value:
                    selectedAnimalId.value == 0 ? null : selectedAnimalId.value,
                decoration: const InputDecoration(
                  labelText: "Vincular Animal (opcional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                items: animals
                    .map((animal) => DropdownMenuItem<int>(
                          value: animal.id,
                          child: Text(animal.nome),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedAnimalId.value = value;
                },
                isExpanded: true,
                hint: const Text("Selecione um animal para marcar no post"),
              );
            }),
          if (isShelter) const SizedBox(height: 20),
          TextFormField(
            controller: homeController.descricaoController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: "Descrição",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            maxLines: 4,
            minLines: 4,
          ),
          const SizedBox(height: 30),
          FilledButtonWidget(
            label: "Postar",
            onPressed: () => {
              if (isShelter && selectedAnimalId != null)
                homeController.postar(
                    selectedAnimalId.value == 0 ? null : selectedAnimalId.value)
              else
                homeController.postar(),
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
