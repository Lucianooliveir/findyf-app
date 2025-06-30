import 'package:findyf_app/commons/models/user_model.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  String token = "";
  late UserModel userInfos;

  updateUserInfos(Map<String, dynamic> json) {
    userInfos = UserModel.fromJson(json);
    print(userInfos);
  }
}
