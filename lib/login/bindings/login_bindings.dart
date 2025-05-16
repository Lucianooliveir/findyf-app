import 'package:findyf_app/commons/controllers/global_controller.dart';
import 'package:findyf_app/login/controllers/login_controller.dart';
import 'package:get/instance_manager.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => GlobalController());
  }
}
