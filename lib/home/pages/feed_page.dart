import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:findyf_app/home/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.postagens.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return ListView.builder(
        itemCount: homeController.postagens.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              PostWidget(postagem: homeController.postagens[index]),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      );
    });
  }
}
