// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shulesmart/repository/conn_client.dart';
import 'package:shulesmart/repository/parent_dash.dart';
import 'package:shulesmart/screens/vendor/selling_screen.dart';
import 'package:shulesmart/utils/utils.dart';

part "vendor_dash.g.dart";

@JsonSerializable()
class ProductItem {
  int id;
  DateTime inserted_at, updated_at, purchase_date;
  String price, product_name;
  String? image;
  double price_raw;

  ProductItem({
    required this.id,
    required this.inserted_at,
    required this.updated_at,
    required this.purchase_date,
    required this.price,
    required this.product_name,
    required this.price_raw,
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

@JsonSerializable()
class SoldItem {
  int id, quantity;
  String total, purchase_price;
  ProductItem product;

  SoldItem({
    required this.id,
    required this.quantity,
    required this.total,
    required this.purchase_price,
    required this.product,
  });

  factory SoldItem.fromJson(Map<String, dynamic> json) =>
      _$SoldItemFromJson(json);

  Map<String, dynamic> toJson() => _$SoldItemToJson(this);
}

@JsonSerializable()
class Student {
  int id;
  String first_name, last_name;

  Student({
    required this.id,
    required this.first_name,
    required this.last_name,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CompletedSale {
  int id;
  List<SoldItem> items;
  Student student;
  String total;

  DateTime inserted_at, updated_at;

  CompletedSale({
    required this.id,
    required this.items,
    required this.student,
    required this.total,
    required this.inserted_at,
    required this.updated_at,
  });

  factory CompletedSale.fromJson(Map<String, dynamic> json) =>
      _$CompletedSaleFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedSaleToJson(this);
}

Future<Result<CompletedSale, String>> submit_new_sale(
    List<CartItem> cart_items, int timestamp, int student_id) async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.post_with_auth("/api/vendors/sales", {
      "student_id": 2,
      "timestamp": timestamp,
      "items": cart_items.map(
        (e) {
          return {"product_id": e.product.id, "quantity": e.quantity};
        },
      ).toList()
    });

    if (response.statusCode != 200) {
      return Result.err("Something went wrong. Please try again later");
    }

    var json = jsonDecode(response.body)["data"];
    return Result.ok(CompletedSale.fromJson(json));
  } catch (e) {
    log(e.toString());
    return Result.err("");
  }
}

/// Add pagination later
Future<Result<List<CompletedSale>, String>> fetch_all_sales() async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth("/api/vendors/sales");

    if (response.statusCode != 200) {
      return Result.err("Something went wrong. Please try again later");
    }

    var json = jsonDecode(response.body)["data"];
    List<CompletedSale> completed_sale_list =
        List.from(json.map((e) => CompletedSale.fromJson(e)).toList());

    return Result.ok(completed_sale_list);
  } catch (e) {
    return Result.err("");
  }
}

@JsonSerializable(explicitToJson: true)
class VendorAccountState {
  String account_balance;
  List<StudentTransaction> recent_transactions;

  VendorAccountState({
    required this.account_balance,
    required this.recent_transactions,
  });

  factory VendorAccountState.fromJson(Map<String, dynamic> json) =>
      _$VendorAccountBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$VendorAccountBalanceToJson(this);
}

Future<Either<String, VendorAccountState>> fetch_vendors_account_state() async {
  var client = ApiClient.get_instance();

  try {
    var response = await client.get_with_auth("/api/vendors/account/");
    log(response.body);

    if (response.statusCode != 200) {
      return const Left("value");
    }
    return Right(
      VendorAccountState.fromJson(
        jsonDecode(response.body)["data"],
      ),
    );
  } catch (e) {
    return const Left("");
  }
}
