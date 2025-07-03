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
    return Column(
      children: [
        Obx(
          () => InkWell(
            onTap: () => homeController.escolherImagem(),
            child: Container(
              height: 400,
              width: 1000,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: homeController.trocou.value
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: homeController.file.value.image,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Toque para adicionar uma imagem",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "JPG, PNG ou JPEG",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
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
    );
  }
}
