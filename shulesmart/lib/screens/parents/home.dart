// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shulesmart/models/student.dart';
import 'package:shulesmart/repository/parent_dash.dart';
import 'package:shulesmart/screens/parents/assign_child.dart';
import 'package:shulesmart/utils/utils.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  List<Student> _your_students = [];

  Future<void> _load_students() async {
    var result = await fetch_students_belonging_to_parent();

    if (result case Result(value: var value) when value != null) {
      setState(() {
        _your_students = value;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _load_students();
  }

  void _handle_assign_student() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AssignStudent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("You Students"),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _load_students();
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _your_students.length,
                (context, index) => ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    "${_your_students[index].first_name} ${_your_students[index].last_name}",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handle_assign_student,
        label: const Text("Assign Student"),
      ),
    );
  }
}
