import 'dart:convert';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShelterController extends GetxController {
  final GlobalController globalController = Get.find();

  // Form controllers
  final TextEditingController nomeResponsavelController =
      TextEditingController();
  final TextEditingController crmvController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  Future<void> cadastrarAbrigo() async {
    // Validate form fields
    if (nomeResponsavelController.text.trim().isEmpty) {
      Get.snackbar(
        "Erro",
        "Por favor, digite o nome do responsável",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (crmvController.text.trim().isEmpty) {
      Get.snackbar(
        "Erro",
        "Por favor, digite o CRMV",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (telefoneController.text.trim().isEmpty) {
      Get.snackbar(
        "Erro",
        "Por favor, digite o telefone",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    // Check if user is logged in
    if (globalController.userInfos.value == null) {
      Get.snackbar(
        "Erro",
        "Usuário não está logado",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      isLoading.value = true;

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "nome_responsavel": nomeResponsavelController.text.trim(),
        "crmv_responsavel": crmvController.text.trim(),
        "telefone": telefoneController.text.trim(),
        "user_infos": globalController.userInfos.value!.id,
      };

      // Make the API call
      final response = await http.post(
        Uri.parse("${Variables.baseUrl}/auth/cadastrarAbrigo"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${globalController.token}',
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success - the user will need to log out and log back in
        // to get the updated user info with the abrigo object
        Get.snackbar(
          "Sucesso",
          "Abrigo cadastrado com sucesso! Faça login novamente para acessar as funcionalidades do abrigo.",
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );

        // Clear form
        nomeResponsavelController.clear();
        crmvController.clear();
        telefoneController.clear();

        // Navigate back to home
        Get.back();
      } else {
        // Error from server
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Erro desconhecido';
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
        "Erro de conexão. Tente novamente.",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      print("Error cadastrando abrigo: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nomeResponsavelController.dispose();
    crmvController.dispose();
    telefoneController.dispose();
    super.onClose();
  }
}
