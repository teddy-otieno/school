import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shulesmart/screens/login_screen.dart';
import 'package:shulesmart/screens/parents/dash.dart';
import 'package:shulesmart/utils/store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var state = StoreProvider.of<AppState>(context).state;

    Timer(const Duration(seconds: 2), () {
      if (state case AppState(session: var session) when session != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ParentDashboard(),
          ),
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Shule Smart",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballScaleMultiple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
