import 'package:findyf_app/commons/controllers/animal_controller.dart';
import 'package:findyf_app/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AnimalController());
  }
}
