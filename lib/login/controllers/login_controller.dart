import 'package:dio/dio.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool senha = true.obs;
  GlobalController globalController = Get.find();

  final dio = Dio();

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController numeroController = TextEditingController();

  void visibilidadeSenha() {
    senha.value = !senha.value;
  }

  void enviarCadastro() async {
    try {
      final response = await dio.post(
        "${Variables.baseUrl}${Variables.cadastroUrl}",
        data: {
          "nome": nomeController.text,
          "email": emailController.text,
          "senha": senhaController.text,
          "telefone": telefoneController.text,
          "cep": cepController.text,
          "numero": numeroController.text,
        },
      );
      globalController.token = response.data["token"];

      Get.toNamed("/home");
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        Get.snackbar("Erro",
            "Este e-mail já foi utilizado para outro cadastro, por favor utilize outro");
      }
    } catch (e) {
      Get.snackbar("Erro", "Erro ao se cadastrar, tente novamente mais tarde");
    } finally {}
  }

  void concluirCadastro() {
    bool preenchidos = nomeController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        senhaController.text.isNotEmpty &&
        telefoneController.text.isNotEmpty &&
        cepController.text.isNotEmpty &&
        numeroController.text.isNotEmpty;

    if (!preenchidos) {
      Get.snackbar("Erro",
          "Por favor preencha todas as informações para fazer seu cadastro");
      return;
    }

    bool emailValido = GetUtils.isEmail(emailController.text);

    if (!emailValido) {
      Get.snackbar("Erro",
          "Por favor digite um email válido, exemplo: exemplo@email.com");
      return;
    }
    enviarCadastro();
  }

  void login() async {
    if (emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar("Erro", "Por favor preencha o campo de email e senha");
      return;
    }

    try {
      final response = await dio.post(
        "${Variables.baseUrl}${Variables.loginUrl}",
        data: {
          "email": emailController.text,
          "senha": senhaController.text,
        },
      );
      globalController.token = response.data["token"];
      Get.toNamed("/home");
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        Get.snackbar("Erro", "Email ou senha errados");
      }
    } catch (e) {
      Get.snackbar(
          "Erro", "Erro ao entrar, por favor tente novamente mais tarde");
    } finally {}
  }
}
