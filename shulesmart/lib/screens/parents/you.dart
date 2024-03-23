// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:moment_dart/moment_dart.dart';
import 'package:shulesmart/models/parents.dart';
import 'package:shulesmart/repository/parent_dash.dart';

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({super.key});

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  fp.Option<ParentProfile> _parent_profile = fp.Option.none();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _load_data() async {
    var result = await fetch_parent_profile_and_transactions();

    if (result case fp.Left(value: final value)) {
      //TODO: Show an error messageo
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(value.error),
        ),
      );
    }

    setState(() {
      _parent_profile = result.toOption();
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: (teddy) for the top bar use the username from the redux store

    return RefreshIndicator(
      onRefresh: _load_data,
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Hello world"),
          ),
          SliverList.separated(
            itemCount:
                _parent_profile.match(() => 0, (t) => t.transactions.length),
            itemBuilder: (context, index) {
              var item = _parent_profile.toNullable()!.transactions[index];
              var moment = item.inserted_at.toMoment();

              return ListTile(
                dense: true,
                leading: item.type == TransactionType.debit
                    ? const Icon(Icons.add_rounded, color: Colors.greenAccent)
                    : const Icon(Icons.remove_rounded, color: Colors.redAccent),
                title: Text(
                  item.type == TransactionType.debit ? item.debit : item.credit,
                ),
                subtitle: Text(item.comment),
                trailing: Text(moment.fromNow()),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          )
        ],
      ),
    );
  }
}
