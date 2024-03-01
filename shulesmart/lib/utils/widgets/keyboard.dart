// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  void Function(String text) on_change_text;

  CustomKeyboard({super.key, required this.on_change_text});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String _text_buffer = "";

  void _handle_key_pressed(int key) {
    _text_buffer += key.toString();

    widget.on_change_text(_text_buffer);
  }

  void _hande_back_space() {
    if (_text_buffer.isEmpty) {
      return;
    }
    _text_buffer = _text_buffer.substring(0, _text_buffer.length - 1);

    widget.on_change_text(_text_buffer);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * (3 / 4) + 200;

    List<Widget> children = List.generate(
      9,
      (index) => InkWell(
        onTap: () => _handle_key_pressed(index + 1),
        child: SizedBox.square(
          dimension: 24,
          child: Center(
            child: Text(
              "${index + 1}",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
    children.addAll([
      InkWell(
        onTap: _hande_back_space,
        child: const SizedBox.square(
          dimension: 24,
          child: Icon(Icons.backspace),
        ),
      ),
      InkWell(
        onTap: () => _handle_key_pressed(0),
        child: SizedBox.square(
          dimension: 24,
          child: Center(
            child: Text(
              "0",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      )
    ]);
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      children: children,
    );
  }
}
