import 'package:findyf_app/commons/models/user_model.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:dio/dio.dart' as di;
import 'package:get/get.dart';

class GlobalController extends GetxController {
  String token = "";
  Rx<UserModel?> userInfos = Rx<UserModel?>(null);
  final dio = di.Dio();

  updateUserInfos(Map<String, dynamic> json) {
    userInfos.value = UserModel.fromJson(json);
    print(userInfos.value);
  }

  bool isPostLiked(int postId) {
    if (userInfos.value == null) return false;
    return userInfos.value!.curtidos.contains(postId);
  }

  void updateLikedPosts(int postId, bool isLiked) {
    if (userInfos.value == null) return;

    List<int> currentLikes = List.from(userInfos.value!.curtidos);

    if (isLiked && !currentLikes.contains(postId)) {
      currentLikes.add(postId);
    } else if (!isLiked && currentLikes.contains(postId)) {
      currentLikes.remove(postId);
    }

    userInfos.value = UserModel(
      id: userInfos.value!.id,
      nome: userInfos.value!.nome,
      telefone: userInfos.value!.telefone,
      email: userInfos.value!.email,
      cep: userInfos.value!.cep,
      imagem_perfil: userInfos.value!.imagem_perfil,
      curtidos: currentLikes,
      postagens: userInfos.value!.postagens,
      isShelter: userInfos.value!.isShelter,
    );
  }
}
