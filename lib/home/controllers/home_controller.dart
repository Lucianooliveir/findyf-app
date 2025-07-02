import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as di;
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/models/postagem_model.dart';
import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;

  final GlobalController globalController = Get.find();
  bool trocou = false;
  TextEditingController descricaoController = TextEditingController();
  List<PostagemModel> postagens = [];

  final dio = di.Dio();

  @override
  void onInit() {
    super.onInit();
    start();
  }

  start() async {
    getPostagens();
  }

  late File imgBack;
  Rx<Image> file = Image.asset("assets/images/pfp.png").obs;

  getPostagens() async {
    di.Response response = await dio.get(
      "${Variables.baseUrl}${Variables.getPostagens}",
      options: di.Options(
        headers: {
          "authorization": "Bearer ${globalController.token}",
        },
      ),
    );
    for (int i = 0; i < response.data.length; i++) {
      postagens.add(PostagemModel.fromJson(response.data[i]));
    }
  }

  List<PostagemModel> getPaginatedPostagens(int page) {
    int startIndex = page * 10;
    int endIndex = startIndex + 10;
    if (startIndex >= postagens.length) {
      return [];
    }
    return postagens.sublist(
        startIndex, endIndex > postagens.length ? postagens.length : endIndex);
  }

  Future<XFile?> escolherImagem() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickedFile.path, uiSettings: [
        IOSUiSettings(cropStyle: CropStyle.rectangle),
        AndroidUiSettings(cropStyle: CropStyle.rectangle)
      ]);
      imgBack = File(croppedFile!.path);
      file.value = await convertFileToImage(File(croppedFile.path));
      trocou = true;
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

  void postar() async {
    if (!trocou || descricaoController.text.isEmpty) {
      Get.snackbar(
          "Erro", "Escolha uma imagem e escreva uma descrição para postar");
      return;
    }

    di.FormData fd = di.FormData.fromMap(
      {
        "texto": descricaoController.text,
        "file": await di.MultipartFile.fromFile(imgBack.path),
        "user_infos": globalController.userInfos.id,
      },
    );

    try {
      // ignore: unused_local_variable
      di.Response response = await dio.post(
        "${Variables.baseUrl}${Variables.postar}",
        data: fd,
        options: di.Options(
          headers: {"authorization": "Bearer ${globalController.token}"},
        ),
      );

      Get.dialog(
        await Get.defaultDialog(
          title: "Post criado com sucesso!",
          middleText: "Post criado com sucesso, pode voltar a navegar agora",
          confirm: FilledButtonWidget(
            label: "Confirmar",
            onPressed: () => {
              descricaoController.text = "",
              file.value = Image.asset("assets/images/pfp.png"),
              trocou = false,
              Get.back(),
              index.value = 0,
            },
          ),
        ),
      );
    } on di.DioException {
      Get.snackbar("Erro",
          "Ocorreu um erro ao criar a postagem, tente novamente mais tarde");
    }
  }
}
