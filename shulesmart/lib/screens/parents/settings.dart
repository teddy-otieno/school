// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shulesmart/screens/login_screen.dart';
import 'package:shulesmart/utils/store.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _handle_logout() {
    //NOTE: (teddy) Clear the entire state
    log("Something is running at the moment");
    StoreProvider.of<AppState>(context).dispatch(ClearSession());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Hello John Doe"),
            actions: [
              IconButton(
                tooltip: "Logout",
                onPressed: _handle_logout,
                icon: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
