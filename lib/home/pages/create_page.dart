import 'package:findyf_app/commons/widgets/filled_button_widget.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class CreatePage extends StatelessWidget {
  CreatePage({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () => homeController.escolherImagem(),
            child: Container(
              height: 400,
              width: 1000,
              color: Colors.black,
              child: Image(
                image: homeController.file.value.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: homeController.descricaoController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: "Descrição",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            maxLines: 4,
            minLines: 4,
          ),
          const Spacer(),
          FilledButtonWidget(
            label: "Postar",
            onPressed: () => {
              homeController.postar(),
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
