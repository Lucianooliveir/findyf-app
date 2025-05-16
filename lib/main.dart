import 'package:findyf_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: "/login",
    getPages: appRoutes,
  ));
}
