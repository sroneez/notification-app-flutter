import 'package:get/get.dart';
import '../../data/repositories/firebase_auth_repo_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Put the Repository in memory permanently
    Get.put<AuthRepository>(FirebaseAuthRepoImpl(), permanent: true);

    // 2. Put the Controller in memory permanently, injecting the Repo
    Get.put<AuthController>(AuthController(Get.find<AuthRepository>()), permanent: true);
  }
}