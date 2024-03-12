// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/repository/vendor_dash.dart';
import 'package:shulesmart/utils/utils.dart';
import 'package:shulesmart/utils/widgets/image_thumb.dart';

class SellingScreen extends StatefulWidget {
  const SellingScreen({super.key});

  @override
  State<SellingScreen> createState() => _SellingScreenState();
}

class CartItem {
  ProductItem product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class _SellingScreenState extends State<SellingScreen> {
  List<ProductItem> _product_items = [];
  List<CartItem> _cart_items = [];

  int _current_time_stamp = 0;

  @override
  void initState() {
    super.initState();
    _load_product_items();
    _current_time_stamp = DateTime.now().millisecondsSinceEpoch;
  }

  void _load_product_items() async {
    var result = await fetch_vendor_products();

    if (result case Result(value: var value) when value != null) {
      setState(() {
        _product_items = value;
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Something went wrong"),
    ));
  }

  void _handle_add_item_to_cart(ProductItem item) {
    var existing_index =
        _cart_items.indexWhere((element) => element.product.id == item.id);

    if (existing_index < 0) {
      //NOTE: (teddy) This is a new element
      setState(() {
        _cart_items.add(CartItem(product: item, quantity: 1));
        _cart_items = [..._cart_items];
      });
      return;
    }
    setState(() {
      _cart_items.removeWhere((element) => element.product.id == item.id);
      _cart_items = [..._cart_items];
    });
  }

  bool is_product_selected(ProductItem item) {
    var existing_index =
        _cart_items.indexWhere((element) => element.product.id == item.id);

    log(existing_index.toString());
    return existing_index >= 0;
  }

  CartItem? get_cart_item(ProductItem item) {
    try {
      return _cart_items.firstWhere(
        (element) => element.product.id == item.id,
      );
    } catch (e) {
      return null;
    }
  }

  void _increment_item(ProductItem item) {
    var cart_item = get_cart_item(item);
    if (cart_item == null) {
      return;
    }

    setState(() {
      cart_item.quantity += 1;
    });
  }

  void _decrement_item(ProductItem item) {
    var cart_item = get_cart_item(item);
    if (cart_item == null) {
      return;
    }

    setState(() {
      cart_item.quantity -= 1;
    });
  }

  void _submit_new_sale() async {
    //FIXME: (teddy) Add a student identification, or student confirmation
    submit_new_sale(_cart_items, _current_time_stamp, 2);
  }

  void _show_cart(BuildContext context) {
    var total_amount = _cart_items.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (element.quantity.toDouble() * element.product.price_raw),
    );

    Scaffold.of(context).showBottomSheet(
      enableDrag: true,
      // context: context,
      (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Checkout",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (var cart_item in _cart_items)
              ListTile(
                leading: ImageThumb(image_path: cart_item.product.image),
                subtitle:
                    Text("${cart_item.product.price} x ${cart_item.quantity}"),
                title: Text(cart_item.product.product_name),
                trailing: Text(
                    "KES${cart_item.product.price_raw * cart_item.quantity}"),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () async {},
                child: Text("Checkout KES $total_amount"),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var total_quantity = _cart_items.fold(
      0,
      (value, element) => value + element.quantity,
    );

    return Scaffold(
      body: Builder(builder: (context) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("Selling"),
              actions: [
                Badge(
                  alignment: Alignment.topLeft,
                  label: Text(total_quantity.toString()),
                  child: IconButton(
                    onPressed: () => _show_cart(context),
                    icon: const Icon(Icons.shopping_cart),
                  ),
                )
              ],
            ),
            SliverGrid.builder(
              itemCount: _product_items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                var item = _product_items[index];

                return Card.filled(
                  elevation: 0,
                  color: is_product_selected(item)
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  child: InkWell(
                    onTap: () {
                      _handle_add_item_to_cart(item);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: (item.image != null)
                                ? Image.network(
                                    create_path(item.image!).toString(),
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    headers: {
                                      "Authorization":
                                          "Bearer ${ApiClient.get_instance().token!}",
                                    },
                                  )
                                : Container(
                                    width: double.infinity,
                                    decoration:
                                        const BoxDecoration(color: Colors.grey),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item.product_name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              Text(item.price,
                                  style:
                                      Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                        if (get_cart_item(item) != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _increment_item(item);
                                },
                                icon: const Icon(Icons.add),
                              ),
                              Text(
                                get_cart_item(item)?.quantity.toString() ?? "0",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              IconButton(
                                onPressed: () {
                                  _decrement_item(item);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            ],
                          )
                        else
                          const SizedBox()
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      }),
    );
  }
}
