// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      session: json['session'] == null
          ? null
          : UserSession.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'session': instance.session?.toJson(),
    };
