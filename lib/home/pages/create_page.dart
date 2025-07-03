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
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as di;

class CreatePage extends StatelessWidget {
  CreatePage({super.key});
  final HomeController homeController = Get.find();
  final GlobalController globalController = Get.find();
  final AnimalController animalController = Get.put(AnimalController());

  // Event form controllers
  final TextEditingController nomeEventoController = TextEditingController();
  final TextEditingController descricaoEventoController =
      TextEditingController();
  final TextEditingController precoEventoController = TextEditingController();
  final TextEditingController horarioEventoController = TextEditingController();
  final Rx<DateTime?> dataInicioEvento = Rx<DateTime?>(null);
  final Rx<DateTime?> dataFimEvento = Rx<DateTime?>(null);
  final RxBool isLoadingEvento = false.obs;

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
        length: 3,
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
                Tab(
                  icon: Icon(Icons.event),
                  text: "Criar Evento",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRegularPostForm(
                      isShelter: true, selectedAnimalId: selectedAnimalId),
                  CreateAnimalForm(),
                  _buildEventForm(context),
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

  Widget _buildEventForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Criar Evento",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            controller: nomeEventoController,
            decoration: const InputDecoration(
              labelText: "Nome do Evento",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descricaoEventoController,
            decoration: const InputDecoration(
              labelText: "Descrição",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(() => InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) dataInicioEvento.value = picked;
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Data Início",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          dataInicioEvento.value == null
                              ? "Selecione"
                              : DateFormat('dd/MM/yyyy')
                                  .format(dataInicioEvento.value!),
                        ),
                      ),
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) dataFimEvento.value = picked;
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Data Fim",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          dataFimEvento.value == null
                              ? "Selecione"
                              : DateFormat('dd/MM/yyyy')
                                  .format(dataFimEvento.value!),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: precoEventoController,
            decoration: const InputDecoration(
              labelText: "Preço",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: horarioEventoController,
            decoration: const InputDecoration(
              labelText: "Horário",
              border: OutlineInputBorder(),
              hintText: "Ex: 14:00 - 18:00",
            ),
          ),
          const SizedBox(height: 30),
          Obx(() => isLoadingEvento.value
              ? const Center(child: CircularProgressIndicator())
              : FilledButtonWidget(
                  label: "Criar Evento",
                  onPressed: () => _submitEvent(context),
                )),
        ],
      ),
    );
  }

  Future<void> _submitEvent(BuildContext context) async {
    if (nomeEventoController.text.trim().isEmpty ||
        descricaoEventoController.text.trim().isEmpty ||
        dataInicioEvento.value == null ||
        dataFimEvento.value == null) {
      Get.snackbar("Erro", "Preencha todos os campos obrigatórios");
      return;
    }
    isLoadingEvento.value = true;
    try {
      final dio = homeController.dio;
      final response = await dio.post(
        "http://localhost:8080/eventos/createEvento",
        data: {
          "nome": nomeEventoController.text.trim(),
          "descricao": descricaoEventoController.text.trim(),
          "dataInicio": dataInicioEvento.value!.toIso8601String(),
          "dataFim": dataFimEvento.value!.toIso8601String(),
          "preco": precoEventoController.text.trim(),
          "horario": horarioEventoController.text.trim(),
          "abrigoId": globalController.userInfos.value?.abrigo?.id
        },
        options: di.Options(
          headers: {"authorization": "Bearer ${globalController.token}"},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        nomeEventoController.clear();
        descricaoEventoController.clear();
        precoEventoController.clear();
        horarioEventoController.clear();
        dataInicioEvento.value = null;
        dataFimEvento.value = null;
        Get.snackbar("Sucesso", "Evento criado com sucesso!",
            backgroundColor: Colors.green[100], colorText: Colors.green[800]);
      } else {
        Get.snackbar("Erro", "Erro ao criar evento");
      }
    } catch (e) {
      Get.snackbar("Erro", "Erro ao criar evento: $e");
    } finally {
      isLoadingEvento.value = false;
    }
  }
}
