import 'package:findyf_app/commons/bindings/global_bindings.dart';
import 'package:findyf_app/home/bindings/home_bindings.dart';
import 'package:findyf_app/home/pages/home_page.dart';
import 'package:findyf_app/home/pages/other_user_profile_page.dart';
import 'package:findyf_app/home/pages/post_page.dart';
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
    bindings: [LoginBindings(), GlobalBindings()],
    children: [
      GetPage(
        name: "/sign_in",
        page: () => SignInPage(),
        bindings: [LoginBindings(), GlobalBindings()],
      ),
      GetPage(
        name: "/cadastro",
        page: () => CadastroPage(),
        bindings: [LoginBindings(), GlobalBindings()],
      ),
      GetPage(
        name: "/customizar",
        page: () => CustomizarPage(),
        bindings: [LoginBindings(), GlobalBindings()],
      )
    ],
  ),
  GetPage(
    name: "/home",
    page: () => HomePage(),
    bindings: [HomeBindings(), GlobalBindings()],
  ),
  GetPage(name: "/postagem", page: () => PostPage(), bindings: [
    HomeBindings(),
    GlobalBindings(),
  ]),
  GetPage(
      name: "/other-user-profile",
      page: () => const OtherUserProfilePage(),
      bindings: [
        HomeBindings(),
        GlobalBindings(),
      ]),
];
