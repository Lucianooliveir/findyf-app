import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:findyf_app/home/pages/create_page.dart';
import 'package:findyf_app/home/pages/feed_page.dart';
import 'package:findyf_app/home/pages/perfil_page.dart';
import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Widget> telas = [
    FeedPage(),
    CreatePage(),
    const PerfilPage(),
  ];

  final List<String> titulos = [
    "Home",
    "Criar",
    "Perfil",
  ];

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(titulos[homeController.index.value]),
          actions: homeController.index.value == 2 // Profile tab
              ? [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (String result) {
                      switch (result) {
                        case 'edit_profile':
                          Get.snackbar(
                              "Info", "Funcionalidade em desenvolvimento");
                          break;
                        case 'become_shelter':
                          Get.toNamed("/cadastrar-abrigo");
                          break;
                        case 'logout':
                          globalController.userInfos.value = null;
                          globalController.token = "";
                          Get.offAllNamed("/login");
                          Get.snackbar(
                            "Logout",
                            "Você foi desconectado com sucesso",
                            backgroundColor: Colors.blue[100],
                            colorText: Colors.blue[800],
                          );
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit_profile',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar Perfil'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'become_shelter',
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Tornar-se Abrigo'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title:
                              Text('Sair', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ]
              : null,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (v) => {homeController.index.value = v},
          currentIndex: homeController.index.value,
          backgroundColor: Appcolors.backgroundColor,
          selectedItemColor: Appcolors.primaryColor,
          // unselectedItemColor: Appcolors.textColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "adicionar"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "perfil"),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: telas[homeController.index.value],
        ),
      ),
    );
  }
}
