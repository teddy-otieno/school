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
