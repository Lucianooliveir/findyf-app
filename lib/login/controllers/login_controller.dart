import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as di;
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LoginController extends GetxController {
  RxBool senha = true.obs;
  GlobalController globalController = Get.find();

  final dio = di.Dio();

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  Rx<Image> file = Image.asset("assets/images/pfp.png").obs;
  late File imgBack;

  void visibilidadeSenha() {
    senha.value = !senha.value;
  }

  void enviarCadastro() async {
    try {
      var formdata = di.FormData.fromMap({
        "nome": nomeController.text,
        "email": emailController.text,
        "senha": senhaController.text,
        "telefone": telefoneController.text,
        "cep": cepController.text,
        "file": await di.MultipartFile.fromFile(imgBack.path),
        "numero": 0
      });
      final response = await dio.post(
        "${Variables.baseUrl}${Variables.cadastroUrl}",
        data: formdata,
      );
      globalController.token = response.data["token"];

      Get.toNamed("/home");
    } on di.DioException catch (e) {
      if (e.response?.statusCode == 409) {
        Get.snackbar("Erro",
            "Este e-mail já foi utilizado para outro cadastro, por favor utilize outro");
      }
    } catch (e) {
      Get.snackbar("Erro", "Erro ao se cadastrar, tente novamente mais tarde");
    } finally {}
  }

  void concluirCadastro() {
    bool preenchidos = emailController.text.isNotEmpty &&
        senhaController.text.isNotEmpty &&
        telefoneController.text.isNotEmpty &&
        cepController.text.isNotEmpty;

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
    Get.toNamed("/login/customizar");
  }

  void redefinir() {
    file.value = Image.asset("assets/images/pfp.png");
  }

  void login() async {
    if (emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar("Erro", "Por favor preencha todos os campos!");
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
    } on di.DioException catch (e) {
      if (e.response!.statusCode == 404) {
        Get.snackbar("Erro", "Email ou senha errados");
      }
    } catch (e) {
      Get.snackbar(
          "Erro", "Erro ao entrar, por favor tente novamente mais tarde");
    } finally {}
  }

  Future<XFile?> escolherImagem() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickedFile.path, uiSettings: [
        IOSUiSettings(cropStyle: CropStyle.circle),
        AndroidUiSettings(cropStyle: CropStyle.circle)
      ]);
      imgBack = File(croppedFile!.path);
      file.value = await convertFileToImage(File(croppedFile.path));
    }

    return pickedFile;
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }
}
