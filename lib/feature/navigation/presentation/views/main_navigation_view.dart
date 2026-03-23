import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/nav_controller.dart';

// Dummy pages for the tabs
class HomeView extends StatelessWidget { const HomeView({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('Home Page')); }
class HistoryView extends StatelessWidget { const HistoryView({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('History Page')); }
class SettingsView extends StatelessWidget { const SettingsView({super.key}); @override Widget build(BuildContext context) => const Center(child: Text('Settings Page')); }

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the NavController just for this shell
    Get.put(NavController());

    // The actual pages that belong to the tabs
    final List<Widget> pages = [
      const HomeView(),
      const HistoryView(),
      const SettingsView(),
    ];

    return GetBuilder<NavController>(
        builder: (navController) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Face Auth App'),
              actions: [
                // A quick logout button for testing your AuthController!
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => Get.find<AuthController>().logout(),
                )
              ],
            ),

            // IndexedStack remembers the state of each page!
            body: IndexedStack(
              index: navController.selectedIndex,
              children: pages,
            ),

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navController.selectedIndex,
              onTap: navController.changePage,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          );
        }
    );
  }
}