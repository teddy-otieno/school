import 'package:flutter/material.dart';
import 'package:shulesmart/screens/vendor/selling_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text("Sales"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SellingScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.developer_mode_rounded),
            )
          ],
        )
      ],
    );
  }
}
