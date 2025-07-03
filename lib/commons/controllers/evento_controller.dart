import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/models/evento_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

class EventoController extends GetxController {
  final GlobalController globalController = Get.find();
  final dio = di.Dio();

  // Form controllers
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFimController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isLoadingEventos = false.obs;

  // Events list
  final RxList<EventoModel> eventos = <EventoModel>[].obs;

  // Form validation
  bool get isFormValid {
    return nomeController.text.trim().isNotEmpty &&
        descricaoController.text.trim().isNotEmpty &&
        dataInicioController.text.trim().isNotEmpty &&
        dataFimController.text.trim().isNotEmpty &&
        precoController.text.trim().isNotEmpty &&
        horarioController.text.trim().isNotEmpty;
  }

  // Create event
  Future<bool> criarEvento() async {
    print("aaaaa");
    if (!isFormValid) {
      Get.snackbar(
        "Erro",
        "Por favor, preencha todos os campos obrigatórios",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;

      // Get user's abrigo ID
      final user = globalController.userInfos.value;
      if (user == null) {
        Get.snackbar(
          "Erro",
          "Usuário não encontrado",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (!user.isShelter || user.abrigo == null) {
        Get.snackbar(
          "Erro",
          "Usuário não é um abrigo",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final createEventoDto = CreateEventoDto(
        nome: nomeController.text.trim(),
        descricao: descricaoController.text.trim(),
        dataInicio: dataInicioController.text.trim(),
        dataFim: dataFimController.text.trim(),
        preco: precoController.text.trim(),
        horario: horarioController.text.trim(),
        abrigoId: user.abrigo!.id,
      );
      final response = await dio.post(
        "${Variables.baseUrl}${Variables.createEvento}",
        data: createEventoDto.toJson(),
        options: di.Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${globalController.token}",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the created event
        final EventoModel novoEvento = EventoModel.fromJson(response.data);

        // Add to local list
        eventos.add(novoEvento);

        // Clear form
        clearForm();

        Get.snackbar(
          "Sucesso",
          "Evento criado com sucesso!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      } else {
        Get.snackbar(
          "Erro",
          response.data['message'] ?? "Erro ao criar evento",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } on di.DioException catch (e) {
      Get.snackbar(
        "Erro",
        "Erro de conexão: ${e.message}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get events by shelter
  Future<void> getEventosByAbrigo(int abrigoId) async {
    try {
      isLoadingEventos.value = true;

      final response = await dio.get(
        "${Variables.baseUrl}${Variables.getEventosByAbrigo}/$abrigoId",
        options: di.Options(
          headers: {
            "Authorization": "Bearer ${globalController.token}",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        final List<EventoModel> eventsList =
            responseData.map((json) => EventoModel.fromJson(json)).toList();

        eventos.assignAll(eventsList);
      } else {
        Get.snackbar(
          "Erro",
          "Erro ao carregar eventos",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on di.DioException catch (e) {
      Get.snackbar(
        "Erro",
        "Erro de conexão: ${e.message}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingEventos.value = false;
    }
  }

  // Get all events
  Future<void> getAllEventos() async {
    try {
      isLoadingEventos.value = true;

      final response = await dio.get(
        "${Variables.baseUrl}${Variables.getEventos}",
        options: di.Options(
          headers: {
            "Authorization": "Bearer ${globalController.token}",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        final List<EventoModel> eventsList =
            responseData.map((json) => EventoModel.fromJson(json)).toList();

        eventos.assignAll(eventsList);
      } else {
        Get.snackbar(
          "Erro",
          "Erro ao carregar eventos",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on di.DioException catch (e) {
      Get.snackbar(
        "Erro",
        "Erro de conexão: ${e.message}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingEventos.value = false;
    }
  }

  // Clear form
  void clearForm() {
    nomeController.clear();
    descricaoController.clear();
    dataInicioController.clear();
    dataFimController.clear();
    precoController.clear();
    horarioController.clear();
  }

  @override
  void onClose() {
    nomeController.dispose();
    descricaoController.dispose();
    dataInicioController.dispose();
    dataFimController.dispose();
    precoController.dispose();
    horarioController.dispose();
    super.onClose();
  }
}
