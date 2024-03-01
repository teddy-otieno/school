// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shulesmart/repository/accounts.dart';
import 'package:shulesmart/screens/parents/dash.dart';
import 'package:shulesmart/screens/signup_screen.dart';
import 'package:shulesmart/utils/store.dart';
import 'package:shulesmart/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form_key = GlobalKey<FormState>();
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();

  void _handle_login() async {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text("Login in..."),
      ),
    );

    var result = await send_login_information({
      "email": _email_controller.text,
      "password": _password_controller.text
    });

    if (result case Result(value: var session) when session != null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text("Success"),
        ),
      );

      StoreProvider.of<AppState>(context).dispatch(
        AddSession(session: session),
      );
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ParentDashboard()));
    } else {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(result.error!),
        ),
      );
    }
  }

  void _handle_signup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ParentSignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Wrap(
                direction: Axis.vertical,
                runSpacing: 8,
                children: [
                  Text(
                    "Shule Smart",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    "Login to access Shule Smart Service",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
              const SizedBox(height: 64),
              Form(
                key: _form_key,
                child: Wrap(
                  runSpacing: 8.0,
                  children: [
                    TextFormField(
                      controller: _email_controller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email or Phone Number",
                      ),
                    ),
                    TextFormField(
                      controller: _password_controller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handle_login,
                  child: const Text("Login"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _handle_signup,
                  child: const Text("Signup As Parent"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
