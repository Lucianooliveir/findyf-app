import 'dart:convert';
import 'dart:io';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/models/animal_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AnimalController extends GetxController {
  final GlobalController globalController = Get.find();

  // Form controllers
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController especieController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController porteController = TextEditingController();

  // Image handling
  final RxBool imageSelected = false.obs;
  late File imageFile;
  final Rx<Image> imageWidget = Image.asset("assets/images/pfp.png").obs;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isLoadingAnimals = false.obs;

  // Animals list for shelter
  final RxList<AnimalModel> shelterAnimals = <AnimalModel>[].obs;

  // Form validation
  bool get isFormValid {
    return nomeController.text.trim().isNotEmpty &&
        dataNascimentoController.text.trim().isNotEmpty &&
        especieController.text.trim().isNotEmpty &&
        racaController.text.trim().isNotEmpty &&
        porteController.text.trim().isNotEmpty &&
        imageSelected.value;
  }

  Future<void> selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        imageFile = File(image.path);
        imageWidget.value = Image.file(imageFile);
        imageSelected.value = true;
      }
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Erro ao selecionar imagem: $e",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> createAnimal() async {
    // Validate form
    if (!isFormValid) {
      Get.snackbar(
        "Erro",
        "Por favor, preencha todos os campos e selecione uma imagem",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // Check if user is logged in and is a shelter
    if (globalController.userInfos.value == null) {
      Get.snackbar(
        "Erro",
        "Usuário não está logado",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (!globalController.userInfos.value!.isShelter) {
      Get.snackbar(
        "Erro",
        "Apenas abrigos podem cadastrar animais",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (globalController.userInfos.value!.abrigo == null) {
      Get.snackbar(
        "Erro",
        "ID do abrigo não encontrado. Cadastre-se como abrigo primeiro",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      isLoading.value = true;

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Variables.baseUrl}/animal/createAnimal"),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${globalController.token}',
      });

      // Add form fields
      request.fields['nome'] = nomeController.text.trim();
      request.fields['data_nascimento'] = dataNascimentoController.text.trim();
      request.fields['especie'] = especieController.text.trim();
      request.fields['raca'] = racaController.text.trim();
      request.fields['porte'] = porteController.text.trim();
      request.fields['abrigo_infos'] =
          globalController.userInfos.value!.abrigo!.id.toString();

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send request
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        Get.snackbar(
          "Sucesso",
          "Animal cadastrado com sucesso!",
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );

        // Clear form
        clearForm();
      } else {
        // Error from server
        final errorData = json.decode(responseString);
        final errorMessage = errorData['message'] ?? 'Erro desconhecido';
        Get.snackbar(
          "Erro",
          errorMessage,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      // Network or other error
      Get.snackbar(
        "Erro",
        "Erro ao cadastrar animal: $e",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nomeController.clear();
    dataNascimentoController.clear();
    especieController.clear();
    racaController.clear();
    porteController.clear();
    imageSelected.value = false;
    imageWidget.value = Image.asset("assets/images/pfp.png");
  }

  Future<void> getAnimaisByUserId(int shelterUserId) async {
    try {
      isLoadingAnimals.value = true;

      final response = await http.get(
        Uri.parse(
            "${Variables.baseUrl}/animal/getAnimaisByUserId/$shelterUserId"),
        headers: {
          'Authorization': 'Bearer ${globalController.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> animalList = json.decode(response.body);
        shelterAnimals.value =
            animalList.map((animal) => AnimalModel.fromJson(animal)).toList();
      } else {
        Get.snackbar(
          "Erro",
          "Erro ao buscar animais: ${response.reasonPhrase}",
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Erro ao buscar animais: $e",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoadingAnimals.value = false;
    }
  }

  @override
  void onClose() {
    nomeController.dispose();
    dataNascimentoController.dispose();
    especieController.dispose();
    racaController.dispose();
    porteController.dispose();
    super.onClose();
  }
}
