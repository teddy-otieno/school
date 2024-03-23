// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shulesmart/screens/parents/home.dart';
import 'package:shulesmart/screens/parents/you.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _current_index = 0;
  final screens = const [ParentHomeScreen(), ParentProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: screens[_current_index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current_index,
        onDestinationSelected: (new_destination) {
          setState(() {
            _current_index = new_destination;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'You',
          )
        ],
      ),
    );
  }
}
