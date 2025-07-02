import 'package:findyf_app/commons/config/appcolors.dart';
import 'package:findyf_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    initialRoute: "/login",
    getPages: appRoutes,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Appcolors.backgroundColor,
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Appcolors.textColor),
        backgroundColor: Appcolors.secondaryColor,
        titleTextStyle: TextStyle(
          color: Appcolors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Appcolors.primaryColor),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Appcolors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    ),
  ));
}
