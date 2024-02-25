// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shulesmart/repository/parent_dash.dart';
import 'package:shulesmart/utils/utils.dart';

class AssignStudent extends StatefulWidget {
  const AssignStudent({super.key});

  @override
  State<AssignStudent> createState() => _AssignStudentState();
}

class _AssignStudentState extends State<AssignStudent> {
  final _school_name_controller = TextEditingController();
  final _student_name_controller = TextEditingController();

  List<SchoolStudentSearchValue> _search_results = [];

  int _selected_id = 0;

  void _handle_search_student() async {
    var result = await search_for_student(
      _school_name_controller.text,
      _student_name_controller.text,
    );

    if (result case Result(value: var value) when value != null) {
      setState(() {
        _search_results = value;
      });
    }
  }

  void _handle_assign_parent_to_student() async {
    if (_selected_id == 0) {
      log("Something went wrong");
      return;
    }

    assign_parent_to_id(_selected_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find your child"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: Wrap(
                runSpacing: 8.0,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("School"),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Name"),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: _handle_search_student,
                    child: const Text("Search"),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Results"),
            Wrap(
              children: _search_results
                  .map(
                    (e) => ListTile(
                      onTap: () {
                        setState(() {
                          _selected_id = e.student_id;
                        });
                      },
                      title: Text(e.student_name),
                      leading: const Icon(Icons.school),
                      subtitle: Text(e.school_name),
                      trailing: const Icon(Icons.open_in_new),
                      selected: _selected_id == e.student_id,
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _handle_assign_parent_to_student,
                    child: const Text("Assign"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
