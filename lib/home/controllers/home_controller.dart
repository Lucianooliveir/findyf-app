import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as di;
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/models/postagem_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;

  final GlobalController globalController = Get.find();
  RxBool trocou = false.obs;
  TextEditingController descricaoController = TextEditingController();
  RxList<PostagemModel> postagens = <PostagemModel>[].obs;

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
    try {
      di.Response response = await dio.get(
        "${Variables.baseUrl}${Variables.getPostagens}",
        options: di.Options(
          headers: {
            "authorization": "Bearer ${globalController.token}",
          },
        ),
      );

      // Clear existing posts and add new ones
      postagens.clear();
      for (int i = 0; i < response.data.length; i++) {
        postagens.add(PostagemModel.fromJson(response.data[i]));
      }
    } catch (e) {
      print('Error fetching posts: $e');
      Get.snackbar("Erro", "Erro ao carregar postagens");
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

  Future<void> curtir(int postId) async {
    try {
      bool isCurrentlyLiked = globalController.isPostLiked(postId);

      di.Response response = await dio.post(
        "${Variables.baseUrl}${Variables.curtirPostagem}",
        data: {
          "post_infos": postId,
          "user_infos": globalController.userInfos.value!.id
        },
        options: di.Options(
          headers: {"authorization": "Bearer ${globalController.token}"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update the user's liked posts locally
        globalController.updateLikedPosts(postId, !isCurrentlyLiked);

        // Refresh posts to show updated like count
        await refreshPostagens();
      }
    } catch (e) {
      print('Error liking post: $e');
    }
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
      trocou.value = true;
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
    if (!trocou.value || descricaoController.text.isEmpty) {
      Get.snackbar(
          "Erro", "Escolha uma imagem e escreva uma descrição para postar");
      return;
    }

    di.FormData fd = di.FormData.fromMap(
      {
        "texto": descricaoController.text,
        "file": await di.MultipartFile.fromFile(imgBack.path),
        "user_infos": globalController.userInfos.value!.id,
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear form data
        descricaoController.text = "";
        file.value = Image.asset("assets/images/pfp.png");
        trocou.value = false;

        // Refresh posts to show the new post
        await refreshPostagens();

        // Navigate to home page (feed)
        index.value = 0;

        // Show success message
        Get.snackbar(
          "Sucesso",
          "Post criado com sucesso!",
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      }
    } on di.DioException {
      Get.snackbar("Erro",
          "Ocorreu um erro ao criar a postagem, tente novamente mais tarde");
    }
  }

  Future<void> comentar(int postId, String comentario) async {
    try {
      di.Response response = await dio.post(
        "${Variables.baseUrl}${Variables.comentarPostagem}",
        data: {
          "texto": comentario,
          "postagem": postId,
          "autor": globalController.userInfos.value!.id,
        },
        options: di.Options(
          headers: {"authorization": "Bearer ${globalController.token}"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Sucesso", "Comentário adicionado com sucesso!");
        // Refresh posts to show the new comment
        await refreshPostagens();
      }
    } on di.DioException {
      Get.snackbar("Erro", "Erro ao adicionar comentário. Tente novamente.");
    }
  }

  Future<void> responderComentario(
      int postId, String comentario, int comentarioId) async {
    try {
      di.Response response = await dio.post(
        "${Variables.baseUrl}${Variables.comentarPostagem}",
        data: {
          "texto": comentario,
          "postagem": postId,
          "autor": globalController.userInfos.value!.id,
          "responde": comentarioId,
        },
        options: di.Options(
          headers: {"authorization": "Bearer ${globalController.token}"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Sucesso", "Resposta adicionada com sucesso!");
        // Refresh posts to show the new reply
        await refreshPostagens();
      }
    } on di.DioException {
      Get.snackbar("Erro", "Erro ao adicionar resposta. Tente novamente.");
    }
  }

  Future<void> refreshPostagens() async {
    await getPostagens();
  }
}
