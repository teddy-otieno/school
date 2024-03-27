// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:flutter/material.dart';
import 'package:shulesmart/models/student.dart';
import 'package:shulesmart/repository/parent_dash.dart';
import 'package:shulesmart/screens/parents/assign_child.dart';
import 'package:shulesmart/screens/parents/informatics.dart';
import 'package:shulesmart/screens/parents/student_profile.dart';
import 'package:shulesmart/utils/utils.dart';
import 'package:shulesmart/utils/widgets/image_thumb.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  List<Student> _your_students = [];

  final GlobalKey<RefreshIndicatorState> _refresh_indicator_key =
      GlobalKey<RefreshIndicatorState>();

  fp.Option<ParentInformaticData> _informatics_data = const fp.Option.none();

  Future<void> _load_students() async {
    var result = await fetch_students_belonging_to_parent();

    if (result case Result(value: var value) when value != null) {
      setState(() {
        _your_students = value;
      });
    }
  }

  Future<void> _load_parent_informatics() async {
    var result = await fetch_parent_informatics();

    if (result case fp.Left(value: final error) when context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }

    setState(() {
      _informatics_data = result.toOption();
    });
  }

  void _handle_assign_student() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AssignStudent(),
      ),
    );
  }

  //Since flutter doesn't have any callbacks. we'll load the data when the state is initialized
  //TODO: (teddy) Handle the loading state
  void _load_data() async {
    await Future.wait([_load_students(), _load_parent_informatics()]);
  }

  @override
  void initState() {
    super.initState();
    _load_data();
  }

  void _handle_view_student_profile(Student student) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentProfileView(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learners"),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        key: _refresh_indicator_key,
        onRefresh: () {
          return Future.wait([_load_students(), _load_parent_informatics()]);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _informatics_data.match(
                () => Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
                  ),
                ),
                (value) => ParentInformaticsCard(informatics_data: value),
              ),
            ),
            const SliverToBoxAdapter(child: Divider()),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Text(
                  "Your Learners",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _your_students.length,
                (context, index) {
                  var item = _your_students[index];
                  //TODO: Create seperate tiles for low and ok status
                  return ListTile(
                    leading: ImageThumb(
                      image_path: item.image,
                      default_icon: const Icon(Icons.person),
                    ),
                    tileColor: item.status == StudentAccountStatus.low
                        ? Theme.of(context).colorScheme.errorContainer
                        : null,
                    title: Text(
                      "${item.first_name} ${item.last_name}",
                    ),
                    trailing: Text(
                      _your_students[index].balance,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: item.status == StudentAccountStatus.low
                                ? Theme.of(context).colorScheme.error
                                : null,
                          ),
                    ),
                    onTap: () {
                      _handle_view_student_profile(_your_students[index]);
                    },
                  );
                },
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
