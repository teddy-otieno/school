// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:moment_dart/moment_dart.dart';
import 'package:shulesmart/repository/vendor_dash.dart';
import 'package:shulesmart/screens/splash_screen.dart';
import 'package:shulesmart/utils/store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  fp.Option<VendorAccountState> _account_state = const fp.None();

  @override
  void initState() {
    super.initState();

    _load_account_state();
  }

  Future<void> _load_account_state() async {
    var result = await const fp.Task(fetch_vendors_account_state).run();
    if (!mounted) return;

    switch (result) {
      case fp.Right(value: final state):
        {
          setState(() {
            _account_state = fp.Some(state);
          });
        }
      case fp.Left(value: final error):
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _load_account_state();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("Your Name"),
              actions: [
                StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(ClearSession());
                  },
                  builder: (context, callback) {
                    return IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () {
                        callback();

                        //Navigate to the splash screen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    );
                  },
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Balance"),
                    const SizedBox(height: 8),
                    Text(
                      _account_state
                          .map((t) => t.account_balance)
                          .getOrElse(() => ""),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverList.builder(
              itemCount: _account_state
                  .map((t) => t.recent_transactions.length)
                  .getOrElse(() => 0),
              itemBuilder: (context, index) {
                var transactions = _account_state
                    .map((x) => x.recent_transactions)
                    .getOrElse(() => []);

                var item = transactions[index];
                var from_now = Moment(item.inserted_at).fromNow();
                return ListTile(
                  title: Text(
                    item.debit_entry?.comment ??
                        item.credit_entry?.comment ??
                        "",
                  ),
                  subtitle: Text(
                    item.debit_entry != null ? item.debit : item.credit,
                  ),
                  trailing: Text(from_now),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
