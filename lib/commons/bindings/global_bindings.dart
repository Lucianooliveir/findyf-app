import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:get/get.dart';

class GlobalBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalController());
  }
}
