// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shulesmart/models/user_session.dart';
import 'package:redux_persist/redux_persist.dart';

part "store.g.dart";

@JsonSerializable(explicitToJson: true)
class AppState {
  UserSession? session;

  AppState({this.session});

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  factory AppState.fromDynamicJson(dynamic json) {
    if (json == null) {
      return AppState();
    }

    return _$AppStateFromJson(json);
  }

  AppState copyWith({UserSession? session}) {
    return AppState(session: session ?? this.session);
  }

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

sealed class Action {}

class AddSession extends Action {
  UserSession session;

  AddSession({required this.session});
}

class ClearSession extends Action {

}

AppState reducer(AppState state, dynamic actions) {
  switch (actions) {
    case AddSession(session: var session):
      return state.copyWith(session: session);
	case ClearSession():
		return AppState();
    default:
      return state;
  }
}

class AppStateSerializer implements StateSerializer<AppState> {
  @override
  AppState? decode(Uint8List? data) {
    if (data == null) return null;
    var raw_data = const Utf8Decoder().convert(data);
    Map<String, dynamic> json = jsonDecode(raw_data);
    return AppState.fromJson(json);
  }

  @override
  Uint8List? encode(AppState state) {
    var json = jsonEncode(state.toJson());
    return const Utf8Encoder().convert(json);
  }
}
