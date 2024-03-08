// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shulesmart/repository/conn_client.dart';

class ImageThumb extends StatelessWidget {
  final String? image_path;

  const ImageThumb({super.key, this.image_path});

  @override
  Widget build(BuildContext context) {
    return image_path != null
        ? Container(
            height: 32,
            width: 32,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Image.network(
              create_path(image_path!).toString(),
              height: 32,
              width: 32,
              fit: BoxFit.cover,
              headers: {
                "Authorization": "Bearer ${ApiClient.get_instance().token!}",
              },
            ),
          )
        : Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          );
  }
}
