// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/utils/utils.dart';

part "vendor_dash.g.dart";

@JsonSerializable()
class ProductItem {
  int id;
  DateTime inserted_at, updated_at, purchase_date;
  String price, product_name;
  String? image;

  ProductItem({
    required this.id,
    required this.inserted_at,
    required this.updated_at,
    required this.purchase_date,
    required this.price,
    required this.product_name,
    this.image,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);
}

Future<Result<List<ProductItem>, String>> fetch_vendor_products() async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth("/api/vendors/products");

    if (response.statusCode != 200) {
      log(response.body);
      return Result.err("Something went wrwong");
    }

    var json = jsonDecode(response.body)["data"] as List<dynamic>;
    List<ProductItem> products =
        List.from(json.map((e) => ProductItem.fromJson(e)).toList());

    return Result.ok(products);
  } catch (e) {
    log(e.toString());

    return Result.err("Please check your internet connection");
  }
}

Future<void> post_new_product_item(
    {required String product_name,
    required String description,
    required XFile product_file}) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post_form(
      "/api/vendors/create",
      body: {"product_name": product_name, "description": description},
      files: [
        product_file,
      ],
    );

    log(response.stream.toString());
  } catch (e) {
    log(e.toString());
  }
}

@JsonSerializable(explicitToJson: true)
class ProductWithQuantity {
  int quantity;
  ProductItem product;

  ProductWithQuantity({required this.quantity, required this.product});

  factory ProductWithQuantity.fromJson(Map<String, dynamic> json) =>
      _$ProductWithQuantityFromJson(json);

  Map<String, dynamic> toJson() => _$ProductWithQuantityToJson(this);
}

Future<Result<List<ProductWithQuantity>, String>>
    fetch_all_stock_with_quantity() async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth("/api/vendors/stock");
    if (response.statusCode != 200) {
      return Result.err("Something went wrong");
    }

    var stock_quantities_json =
        jsonDecode(response.body)["data"] as List<dynamic>;

    List<ProductWithQuantity> stock_quantities = List.from(
      stock_quantities_json
          .map((e) => ProductWithQuantity.fromJson(e))
          .toList(),
    );

    return Result.ok(stock_quantities);
  } catch (e) {
    log(e.toString());
    return Result.err("Not internet connection available");
  }
}

Future<Result<List<ProductWithQuantity>, String>>
    fetch_all_products_and_available_quntities() async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth("/api/vendors/stock/product");

    if (response.statusCode != 200) {
      return Result.err("Something went wrong");
    }

    var stock_quantities_json =
        jsonDecode(response.body)["data"] as List<dynamic>;

    List<ProductWithQuantity> stock_quantities = List.from(
      stock_quantities_json
          .map((e) => ProductWithQuantity.fromJson(e))
          .toList(),
    );

    return Result.ok(stock_quantities);
  } catch (e) {
    log(e.toString());
    return Result.err("No internet connection available");
  }
}

@JsonSerializable()
class StockMovement {
  int id, quantity;
  String? comment;

  StockMovement({required this.id, required this.quantity, this.comment});

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);

  Map<String, dynamic> toJson() => _$StockMovementToJson(this);
}

Future<Result<StockMovement, String>> submit_new_stock(
    {required int quantity,
    required int product_id,
    required String comment}) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post_with_auth("/api/vendors/stock",
        {"comment": comment, "product_id": product_id, "quantity": quantity});

    if (response.statusCode != 200) {
      return Result.err("Something went wrong");
    }

    var movement = jsonDecode(response.body)["data"];

    return Result.ok(StockMovement.fromJson(movement));
  } catch (e) {
    log(e.toString());
    return Result.err("");
  }
}
