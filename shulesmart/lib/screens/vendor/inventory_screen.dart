import 'package:flutter/material.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/repository/vendor_dash.dart';
import 'package:shulesmart/screens/vendor/add_new_product.dart';
import 'package:shulesmart/utils/utils.dart';

class InventoryManagerScreen extends StatefulWidget {
  const InventoryManagerScreen({super.key});

  @override
  State<InventoryManagerScreen> createState() => _InventoryManagerScreenState();
}

class _InventoryManagerScreenState extends State<InventoryManagerScreen> {
  List<ProductItem> _products = [];
  Future<void> _load_products() async {
    var result = await fetch_vendor_products();

    if (result case Result(value: var products) when products != null) {
      setState(() {
        _products = products;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _load_products();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load_products,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text("Products"),
            ),
            SliverList.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _products[index].image != null
                      ? Container(
                          height: 32,
                          width: 32,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Image.network(
                            create_path(_products[index].image!).toString(),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                  title: Text(_products[index].product_name),
                  subtitle: Text(_products[index].price),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {},
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddNewProductScreen(),
              ),
            );
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
