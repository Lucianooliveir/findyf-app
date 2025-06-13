import 'package:findyf_app/home/pages/home_page.dart';
import 'package:findyf_app/login/bindings/login_bindings.dart';
import 'package:findyf_app/login/pages/cadastro_page.dart';
import 'package:findyf_app/login/pages/customizar_page.dart';
import 'package:findyf_app/login/pages/login_page.dart';
import 'package:findyf_app/login/pages/sign_in_page.dart';
import 'package:get/route_manager.dart';

final appRoutes = [
  GetPage(
    name: "/login",
    page: () => const LoginPage(),
    binding: LoginBindings(),
    children: [
      GetPage(
        name: "/sign_in",
        page: () => SignInPage(),
        binding: LoginBindings(),
      ),
      GetPage(
        name: "/cadastro",
        page: () => CadastroPage(),
        binding: LoginBindings(),
      ),
      GetPage(
        name: "/customizar",
        page: () => CustomizarPage(),
        binding: LoginBindings(),
      )
    ],
  ),
  GetPage(
    name: "/home",
    page: () => const HomePage(),
  ),
];
