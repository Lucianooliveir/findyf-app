import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:findyf_app/home/pages/create_page.dart';
import 'package:findyf_app/home/pages/feed_page.dart';
import 'package:findyf_app/home/pages/perfil_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

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
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(titulos[homeController.index.value]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (v) => {homeController.index.value = v},
          currentIndex: homeController.index.value,
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
