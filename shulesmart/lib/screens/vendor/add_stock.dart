// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/repository/vendor_dash.dart';
import 'package:shulesmart/utils/utils.dart';

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  List<ProductWithQuantity> _all_products = [];
  int _selected_index = -1;
  final _form_key = GlobalKey<FormState>();
  TextEditingController _quantity_controller = TextEditingController();
  TextEditingController _comment_controller = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _load_all_products_and_quantities();
  }

  Future<void> _load_all_products_and_quantities() async {
    var result = await fetch_all_products_and_available_quntities();

    if (result case Result(value: var value) when value != null) {
      setState(() {
        _all_products = value;
      });
    }

    //TODO: (teddy) Add some error case and handle it
  }

  void _handle_save_stock() async {
    log("Reached here");
    if (_form_key.currentState?.validate() != true) {
      return;
    }

    if (_selected_index < 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please select an item")));
      return;
    }

    var result = await submit_new_stock(
        quantity: int.parse(_quantity_controller.text),
        product_id: _all_products[_selected_index].product.id,
        comment: _comment_controller.text);

    if (result.is_okay()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Stock has been moved")));

      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Something went wrong")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("New Stock"),
            actions: [
              TextButton(
                  onPressed: _handle_save_stock, child: const Text("Save"))
            ],
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _form_key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _quantity_controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Quantity"),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please add a quantity";
                        }

                        var quantity = int.tryParse(value);

                        if (quantity == null) {
                          return "Value is not a number";
                        }

                        if (quantity <= 0) {
                          return "Quantity should be greater than 0";
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _comment_controller,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Comment"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Select Item",
                        style: Theme.of(context).textTheme.titleMedium),
                  )
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _all_products.length,
            itemBuilder: (context, index) {
              var item = _all_products[index];

              return ListTile(
                selected: _selected_index == index,
                onTap: () {
                  setState(() {
                    _selected_index = index;
                  });
                },
                leading: item.product.image != null
                    ? Container(
                        height: 32,
                        width: 32,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                title: Text(item.product.product_name),
                trailing: Text(item.quantity.toString()),
                subtitle: Text(item.product.price),
              );
            },
          )
        ],
      ),
    );
  }
}
