// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shulesmart/screens/vendor/inventory_screen.dart';
import 'package:shulesmart/screens/vendor/sales_screen.dart';
import 'package:shulesmart/screens/vendor/stocks_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenSate();
}

class _VendorDashboardScreenSate extends State<VendorDashboardScreen> {
  final _screens = [
    const StockScreen(),
    const SalesScreen(),
  ];
  int _current_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_current_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current_index,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory),
            label: "Inventory",
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_rounded),
            label: "Sales",
          ),
        ],
        onDestinationSelected: (index) {
          setState(() {
            _current_index = index;
          });
        },
      ),
    );
  }
}
