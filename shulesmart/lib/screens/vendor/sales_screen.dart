// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:shulesmart/screens/vendor/selling_screen.dart';
import 'package:shulesmart/repository/vendor_dash.dart';
import 'package:shulesmart/utils/utils.dart';
import 'package:shulesmart/utils/widgets/image_thumb.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<CompletedSale> _completed_sales = [];

  @override
  void initState() {
    super.initState();
    _load_sales();
  }

  Future<void> _load_sales() async {
    //Load

    var sales_result = await fetch_all_sales();
    if (sales_result case Result(value: var value) when value != null) {
      setState(() {
        _completed_sales = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load_sales,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Todays Sales"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SellingScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.point_of_sale_rounded),
              )
            ],
          ),
          SliverList.separated(
            itemCount: _completed_sales.length,
            itemBuilder: (context, index) {
              var item = _completed_sales[index];

              var moment = item.inserted_at.toMoment();

              return ListTile(
                leading: item.items.length == 1
                    ? ImageThumb(image_path: item.items[0].product.image)
                    : Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "M",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                title: Text(
                  "${item.student.first_name} ${item.student.last_name}",
                ),
                trailing: Text(moment.fromNow()),
                subtitle: Text(item.total),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ],
      ),
    );
  }
}
