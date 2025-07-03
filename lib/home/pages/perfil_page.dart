import 'package:cached_network_image/cached_network_image.dart';
import 'package:findyf_app/commons/config/variables.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/commons/controllers/animal_controller.dart';
import 'package:findyf_app/commons/widgets/verified_user_name.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find();
    final HomeController homeController = Get.find();
    final AnimalController animalController = Get.put(AnimalController());

    return Obx(() {
      if (globalController.userInfos.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = globalController.userInfos.value!;

      // Filter posts from HomeController that belong to this user (similar to OtherUserProfilePage)
      final userPosts = homeController.postagens
          .where((post) => post.user_infos.id == user.id)
          .toList();

      return Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "${Variables.baseUrl}/${user.imagem_perfil}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // User Name
                VerifiedUserName(
                  userName: user.nome,
                  isVerified: user.isShelter,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  iconSize: 24,
                ),
                const SizedBox(height: 8),

                // Posts and Likes Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "${userPosts.length}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Posts",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        Text(
                          "${user.curtidos.length}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Curtidas",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Tab System (only for shelter users)
          if (user.isShelter && user.abrigo != null)
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.grid_on),
                          text: "Posts",
                        ),
                        Tab(
                          icon: Icon(Icons.pets),
                          text: "Animais",
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPostsTab(userPosts, homeController),
                          _buildAnimalsTab(user, animalController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // For non-shelter users, show only posts
            Expanded(
              child: _buildPostsTab(userPosts, homeController),
            ),
        ],
      );
    });
  }

  Widget _buildPostsTab(List userPosts, HomeController homeController) {
    return userPosts.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  "Nenhuma postagem ainda",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Suas postagens aparecerão aqui",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];
                return InkWell(
                  onTap: () {
                    // We already have the full PostagemModel, so navigate directly
                    Get.toNamed("/postagem", arguments: {"postagem": post});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: "${Variables.baseUrl}/${post.imagem_post}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildAnimalsTab(user, AnimalController animalController) {
    // Load animals when tab is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user.abrigo != null) {
        animalController.getAnimaisByUserId(user.abrigo.id);
      }
    });

    return Obx(() {
      if (animalController.isLoadingAnimals.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (animalController.shelterAnimals.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pets_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "Nenhum animal cadastrado",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Use a aba 'Cadastrar Animal' para adicionar animais",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: animalController.shelterAnimals.length,
          itemBuilder: (context, index) {
            final animal = animalController.shelterAnimals[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed("/animal-profile", arguments: {"animal": animal});
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animal Image
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "${Variables.baseUrl}/${animal.imagem}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.pets,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Animal Info
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              animal.nome,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${animal.especie} • ${animal.porte}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              animal.raca,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
