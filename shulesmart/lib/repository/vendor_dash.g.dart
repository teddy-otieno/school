// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItem _$ProductItemFromJson(Map<String, dynamic> json) => ProductItem(
      id: json['id'] as int,
      inserted_at: DateTime.parse(json['inserted_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
      purchase_date: DateTime.parse(json['purchase_date'] as String),
      price: json['price'] as String,
      product_name: json['product_name'] as String,
      price_raw: (json['price_raw'] as num).toDouble(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inserted_at': instance.inserted_at.toIso8601String(),
      'updated_at': instance.updated_at.toIso8601String(),
      'purchase_date': instance.purchase_date.toIso8601String(),
      'price': instance.price,
      'product_name': instance.product_name,
      'image': instance.image,
      'price_raw': instance.price_raw,
    };

ProductWithQuantity _$ProductWithQuantityFromJson(Map<String, dynamic> json) =>
    ProductWithQuantity(
      quantity: json['quantity'] as int,
      product: ProductItem.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductWithQuantityToJson(
        ProductWithQuantity instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'product': instance.product.toJson(),
    };

StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    StockMovement(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$StockMovementToJson(StockMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'comment': instance.comment,
    };

SoldItem _$SoldItemFromJson(Map<String, dynamic> json) => SoldItem(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      total: json['total'] as String,
      purchase_price: json['purchase_price'] as String,
      product: ProductItem.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SoldItemToJson(SoldItem instance) => <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'total': instance.total,
      'purchase_price': instance.purchase_price,
      'product': instance.product,
    };

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
    };

CompletedSale _$CompletedSaleFromJson(Map<String, dynamic> json) =>
    CompletedSale(
      id: json['id'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => SoldItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      student: Student.fromJson(json['student'] as Map<String, dynamic>),
      total: json['total'] as String,
      inserted_at: DateTime.parse(json['inserted_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CompletedSaleToJson(CompletedSale instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'student': instance.student.toJson(),
      'total': instance.total,
      'inserted_at': instance.inserted_at.toIso8601String(),
      'updated_at': instance.updated_at.toIso8601String(),
    };

VendorAccountState _$VendorAccountBalanceFromJson(Map<String, dynamic> json) =>
    VendorAccountState(
      account_balance: json['account_balance'] as String,
      recent_transactions: (json['recent_transactions'] as List<dynamic>)
          .map((e) => StudentTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VendorAccountBalanceToJson(
        VendorAccountState instance) =>
    <String, dynamic>{
      'account_balance': instance.account_balance,
      'recent_transactions':
          instance.recent_transactions.map((e) => e.toJson()).toList(),
    };
