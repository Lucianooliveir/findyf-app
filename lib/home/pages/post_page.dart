import 'package:cached_network_image/cached_network_image.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/models/postagem_model.dart';
import 'package:findyf_app/commons/models/comentario_model.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostagemModel initialPostagem = Get.arguments["postagem"];
  HomeController homeController = Get.find();
  GlobalController globalController = Get.find();
  final TextEditingController comentarioController = TextEditingController();
  ComentarioModel? replyingTo;
  final FocusNode _focusNode = FocusNode();

  // Get the current post data from the controller, or fall back to initial data
  PostagemModel get currentPostagem {
    final updatedPost = homeController.postagens.firstWhereOrNull(
      (post) => post.id == initialPostagem.id,
    );
    return updatedPost ?? initialPostagem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Postagem"),
      ),
      body: Obx(() {
        final postagem = currentPostagem;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post header with user info
                      InkWell(
                        onTap: () => {
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
                      // Post image
                      Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Variables.baseUrl}/${postagem.imagem_post}",
                          height: 300,
                          width: 500,
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      // Like and comment buttons
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async =>
                                  {await homeController.curtir(postagem.id)},
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
                            IconButton(
                              onPressed: () => {},
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Post description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          postagem.texto,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Comments section
                      const Divider(),
                      const Text(
                        "Comentários",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display comments (all comments are main comments, replies are in respostas field)
                      ...postagem.comentarios.map(
                          (comentario) => _buildCommentWithReplies(comentario)),
                    ],
                  ),
                ),
              ),
            ),
            // Comment input field at bottom
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show reply indicator if replying to a comment
                    if (replyingTo != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.reply,
                                color: Colors.blue[700], size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "Respondendo a ${replyingTo!.autor.nome}",
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  replyingTo = null;
                                  comentarioController.clear();
                                });
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.blue[700],
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: comentarioController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: replyingTo != null
                                  ? "Responder comentário..."
                                  : "Escreva um comentário...",
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () async {
                            if (comentarioController.text.trim().isNotEmpty) {
                              if (replyingTo != null) {
                                // Send reply
                                await homeController.responderComentario(
                                  postagem.id,
                                  comentarioController.text.trim(),
                                  replyingTo!.id,
                                );
                              } else {
                                // Send regular comment
                                await homeController.comentar(
                                  postagem.id,
                                  comentarioController.text.trim(),
                                );
                              }
                              comentarioController.clear();
                              setState(() {
                                replyingTo = null;
                              });
                            }
                          },
                          icon: const Icon(Icons.send),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildCommentWithReplies(ComentarioModel comentario) {
    // Use the respostas field directly from the comment
    List<ComentarioModel> replies = comentario.respostas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comment
        _buildCommentWidget(comentario),
        // Replies below the main comment
        if (replies.isNotEmpty) ...[
          const SizedBox(height: 5),
          ...replies.map((reply) => Container(
                margin: const EdgeInsets.only(left: 30, bottom: 10),
                child: _buildReplyWidget(reply),
              )),
        ],
      ],
    );
  }

  Widget _buildReplyWidget(ComentarioModel reply) {
    return GestureDetector(
      onTap: () {
        setState(() {
          replyingTo = reply;
          _focusNode.requestFocus();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: replyingTo?.id == reply.id ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: replyingTo?.id == reply.id
                ? Colors.blue[200]!
                : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.subdirectory_arrow_right,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  radius: 12,
                  backgroundImage: Image.network(
                    "${Variables.baseUrl}/${reply.autor.imagem_perfil}",
                  ).image,
                ),
                const SizedBox(width: 8),
                Text(
                  reply.autor.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.reply,
                  size: 14,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 21),
              child: Text(
                reply.texto,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentWidget(ComentarioModel comentario) {
    return GestureDetector(
      onTap: () {
        setState(() {
          replyingTo = comentario;
          _focusNode.requestFocus();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: replyingTo?.id == comentario.id
              ? Colors.blue[50]
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: replyingTo?.id == comentario.id
              ? Border.all(color: Colors.blue[200]!)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: Image.network(
                    "${Variables.baseUrl}/${comentario.autor.imagem_perfil}",
                  ).image,
                ),
                const SizedBox(width: 8),
                Text(
                  comentario.autor.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.reply,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              comentario.texto,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    comentarioController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
