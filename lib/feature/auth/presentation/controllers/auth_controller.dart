import 'dart:async';
import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  // 1. Standard Variables (No Rx, no .obs)
  UserEntity? currentUser;
  bool isLoading = false;

  // 2. Manual Stream Subscription
  // We need to store this so we can close it later and prevent memory leaks!
  StreamSubscription<UserEntity?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    // 3. Listen to the stream manually
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      currentUser = user;
      update(); // Tell the GetBuilder UI to redraw

      _handleAuthRouting(user); // Trigger the routing manually
    });
  }

  @override
  void onClose() {
    // 4. CRITICAL: Prevent Memory Leaks
    // Because we aren't using GetX's reactive magic, we MUST cancel the stream manually when the controller dies.
    _authSubscription?.cancel();
    super.onClose();
  }

  // --- AUTOMATIC ROUTING ---
  void _handleAuthRouting(UserEntity? user) {
    if (user == null) {
      // 🚨 The Guard: Only force navigation to login if they aren't already on the auth screens!
      if (Get.currentRoute != '/login' && Get.currentRoute != '/signup') {
        Get.offAllNamed('/login');
      }
    } else {
      // User is logged in. Send to Home!
      Get.offAllNamed('/main');
    }
  }

  // --- ACTIONS ---

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      update(); // 🚨 Notify GetBuilder that loading started

      await _authRepository.loginWithEmail(email, password);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update(); // 🚨 Notify GetBuilder that loading finished
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading = true;
      update();

      await _authRepository.signUpWithEmail(email, password);
    } catch (e) {
      Get.snackbar('Sign Up Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    // Notice we don't call update() or routing here.
    // The _authSubscription listener at the top will automatically catch the null user and handle it!
  }
}