import 'package:get/get.dart';
import '../../feature/auth/presentation/bindings/auth_binding.dart';
import '../../feature/auth/presentation/pages/login_view.dart';
import '../../feature/auth/presentation/pages/sign_up_view.dart';
import '../../feature/navigation/presentation/views/main_navigation_view.dart';
import 'app_route.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      // Removed binding here
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpView(),
      // Removed binding here
    ),
    GetPage(
      name: AppRoutes.mainNav,
      page: () => const MainNavigationView(),
    ),
  ];
}