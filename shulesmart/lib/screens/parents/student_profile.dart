// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shulesmart/models/student.dart';
import 'package:shulesmart/repository/parent_dash.dart';
import 'package:shulesmart/utils/widgets/keyboard.dart';
import 'package:shulesmart/utils/utils.dart';

class StudentProfileView extends StatefulWidget {
  final Student student;

  const StudentProfileView({
    super.key,
    required this.student,
  });

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

//Load the student information and transaction history made to that student
//We'll implement the deposit funds feature here
class _StudentProfileViewState extends State<StudentProfileView> {
  List<StudentTransaction> _transactions = [];

  void _initiate_deposit_to_student_account(int amount) async {
    log("Reached here");
    var result =
        await initiate_submit_deposit_to_student(widget.student.id, amount);

    if (result case Result(value: var value) when value != null) {
      Navigator.of(context).pop();
      return;
    }
  }

  void _load_transactions() async {
    var result =
        await fetch_student_recent_transaction_history(widget.student.id);

    if (result case Result(value: var trans) when trans != null) {
      setState(() {
        _transactions = trans;
      });
      return;
    }

    //NOTE: Show some error message later
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _load_transactions();
  }

  void _handle_deposit() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        var amount = "";

        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter set_modal_state,
          ) {
            var amount_number = NumberFormat.currency(symbol: 'KES')
                .format(amount.isEmpty ? 0 : int.parse(amount));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      amount_number,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  CustomKeyboard(
                    on_change_text: (text) {
                      set_modal_state(() {
                        amount = text;
                      });
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        _initiate_deposit_to_student_account(
                          amount.isEmpty ? 0 : int.parse(amount),
                        );
                      },
                      child: const Text("Deposit"),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile")),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          _load_transactions();
        },
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                log(_transactions[index].toJson().toString());

                return ListTile(
                  title: Text(
                    _transactions[index].debit_entry != null
                        ? _transactions[index].debit
                        : _transactions[index].credit,
                  ),
                  subtitle: Text(
                    _transactions[index].debit_entry != null
                        ? _transactions[index].debit_entry!.comment
                        : _transactions[index].credit_entry!.comment,
                  ),
                  trailing: _transactions[index].debit_entry == null
                      ? const Icon(Icons.remove, color: Colors.redAccent)
                      : const Icon(
                          Icons.add,
                          color: Colors.greenAccent,
                        ),
                );
              },
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handle_deposit,
        label: const Text("Make Deposit"),
      ),
    );
  }
}
