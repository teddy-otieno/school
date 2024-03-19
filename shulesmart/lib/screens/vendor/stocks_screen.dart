// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/repository/vendor_dash.dart';
import 'package:shulesmart/screens/vendor/add_stock.dart';
import 'package:shulesmart/utils/utils.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<ProductWithQuantity> _products_with_quantity = [];

  Future<void> _load_stock() async {
    var stock_quantities_result = await fetch_all_stock_with_quantity();

    if (!mounted) return;

    if (stock_quantities_result case Result(value: var quantities)
        when quantities != null) {
      setState(() {
        _products_with_quantity = quantities;
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    _load_stock();
  }

  void _show_add_stock_movement_dialog() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddStockScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load_stock,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Inventory"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_to_photos_rounded),
                )
              ],
            ),
            SliverList.separated(
              itemCount: _products_with_quantity.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                var item = _products_with_quantity[index];
                return ListTile(
                  title: Text(item.product.product_name),
                  leading: item.product.image != null
                      ? Container(
                          height: 32,
                          width: 32,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Image.network(
                            create_path(item.product.image!).toString(),
                            height: 32,
                            width: 32,
                            fit: BoxFit.cover,
                            headers: {
                              "Authorization":
                                  "Bearer ${ApiClient.get_instance().token!}",
                            },
                          ),
                        )
                      : Container(
                          height: 32,
                          width: 32,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                  subtitle: Text(item.product.price),
                  trailing: Text(
                    item.quantity.toString(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _show_add_stock_movement_dialog,
        label: const Text("Add Stock"),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}
