import 'package:flutter/material.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/dashboard/dashboard.dart';
import 'package:my_pup_simple/puppy_profile/puppy_profile.dart';
import 'package:my_pup_simple/clicker/clicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => setState(() {
          _selectedIndex = page;
        }),
        children: const <Widget>[
          DashboardPage(),
          ClickerPage(),
          PuppyProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        },
        // unselectedItemColor: secondaryAppColor,
        // selectedItemColor: mainAppColor,
        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
            selectedIcon: Icon(
              Icons.home,
              color: mainAppColor,
            ),
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.play_circle_outline,
            ),
            label: 'Clicker',
            selectedIcon: Icon(
              Icons.play_circle,
              color: mainAppColor,
            ),
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.pets_outlined,
            ),
            label: 'My Puppy',
            selectedIcon: Icon(
              Icons.pets,
              color: mainAppColor,
            ),
          ),
        ],
      ),
    );
  }
}
