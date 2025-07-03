import 'package:cached_network_image/cached_network_image.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/models/postagem_model.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostWidget extends StatelessWidget {
  PostWidget({super.key, required this.postagem});
  final PostagemModel postagem;
  final HomeController homeController = Get.find();
  final GlobalController globalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Get.toNamed("/postagem", arguments: {"postagem": postagem})
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => {
              print(
                  "Navigating to profile for user: ${postagem.user_infos.nome}"),
              print(
                  "User posts count: ${postagem.user_infos.postagens.length}"),
              Get.toNamed("/other-user-profile",
                  arguments: {"user": postagem.user_infos})
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundImage: Image.network(
                              "${Variables.baseUrl}/${postagem.user_infos.imagem_perfil}")
                          .image,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(postagem.user_infos.nome),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: CachedNetworkImage(
              imageUrl: "${Variables.baseUrl}/${postagem.imagem_post}",
              height: 300,
              width: 500,
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () async => {
                    await homeController.curtir(postagem.id),
                  },
                  icon: Icon(
                    globalController.isPostLiked(postagem.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: globalController.isPostLiked(postagem.id)
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
                Text("${postagem.curtidas.length}"),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              postagem.texto,
              textAlign: TextAlign.start,
              softWrap: true,
              maxLines: 2,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
