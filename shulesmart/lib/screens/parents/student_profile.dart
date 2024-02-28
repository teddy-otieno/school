import 'package:flutter/material.dart';
import 'package:shulesmart/models/student.dart';

class StudentProfileView extends StatefulWidget {
  Student student;

  StudentProfileView({
    super.key,
    required this.student,
  });

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

//Load the student information and transaction history made to that student
//We'll implement the deposit funds feature here
class _StudentProfileViewState extends State<StudentProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile")),
      body: SafeArea(
          child: Center(
        child: Text("Hello world"),
      )),
    );
  }
}
