// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shulesmart/repository/accounts.dart';

class ParentSignupScreen extends StatefulWidget {
  const ParentSignupScreen({super.key});

  @override
  State<ParentSignupScreen> createState() => _ParentSignupScreenState();
}

class _ParentSignupScreenState extends State<ParentSignupScreen> {
  final _form_key = GlobalKey<FormState>();
  final _first_name_controller = TextEditingController();
  final _last_name_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _phone_number_controller = TextEditingController();
  final _password_controller = TextEditingController();
  final _confirm_password_controller = TextEditingController();

  void _handle_clicked() async {
    if (!_form_key.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form Invalid"),
        ),
      );
      return;
    }

    var result = await send_parent_information({
      "first_name": _first_name_controller.text,
      "last_name": _last_name_controller.text,
      "email": _email_controller.text,
      "phone_number": _phone_number_controller.text,
      "password": _password_controller.text,
      "confirm_password": _confirm_password_controller.text
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text((result ? "Success" : "Failed")),
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
            children: [
              const SizedBox(
                height: 16,
              ),
              Wrap(
                direction: Axis.vertical,
                runSpacing: 8,
                children: [
                  Text(
                    "Shule Smart",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    "Sign Up for Shule Smart Cashless services.",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
              const SizedBox(
                height: 64,
              ),
              Form(
                key: _form_key,
                child: Wrap(
                  runSpacing: 8.0,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "First Name",
                      ),
                      controller: _first_name_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Last Name",
                      ),
                      controller: _last_name_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number",
                      ),
                      controller: _phone_number_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email Address",
                      ),
                      controller: _email_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      controller: _password_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }

                        if (value != _confirm_password_controller.text) {
                          return 'Mismatch';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirm Password",
                      ),
                      controller: _confirm_password_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }

                        if (value != _password_controller.text) {
                          return 'Mismatch';
                        }
                        log(value);
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _handle_clicked,
                    child: const Text("Sign Up as Parent"),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
