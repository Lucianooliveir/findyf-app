import 'package:findyf_app/shelter/controllers/shelter_controller.dart';
import 'package:get/get.dart';

class ShelterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShelterController>(() => ShelterController());
  }
}
