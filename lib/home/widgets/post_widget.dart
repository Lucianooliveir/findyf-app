import 'package:cached_network_image/cached_network_image.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/models/postagem_model.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required PostagemModel this.postagem});
  final PostagemModel postagem;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {print("1")},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => {print("2")},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.favorite_border,
                ),
              ),
              const Text("10"),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.chat_bubble_outline,
                ),
              ),
            ],
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
