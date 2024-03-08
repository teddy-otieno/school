// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shulesmart/repository/vendor_dash.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddNewProductScreenState();
  }
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  XFile? _image;

  TextEditingController _name_controller = TextEditingController();
  TextEditingController _description_controller = TextEditingController();

  void _handle_take_photo() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = image;
    });
  }

  void _handle_pick_image_from_gallery() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _image = image;
    });
  }

  void _handle_save_new_product() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Image provided"),
        ),
      );
      return;
    }

    var result = await post_new_product_item(
      product_name: _name_controller.text,
      description: _description_controller.text,
      product_file: _image!,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var width = MediaQuery.of(context).size.width - 16.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Wrap(
                  runSpacing: 8,
                  children: [
                    if (_image == null)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        height: width,
                        width: width,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    else
                      Container(
                        height: width,
                        width: width,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0,
                      runAlignment: WrapAlignment.spaceBetween,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.camera),
                          onPressed: _handle_take_photo,
                          label: const Text(
                            "Take Photo",
                          ),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.browse_gallery),
                          onPressed: _handle_pick_image_from_gallery,
                          label: const Text(
                            "Pick From Gallery",
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _name_controller,
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Product Name"),
                      ),
                    ),
                    TextFormField(
                      controller: _description_controller,
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Description"),
                      ),
                      expands: false,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom > 0)
                const SizedBox()
              else
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _handle_save_new_product,
                        child: const Text("Save"),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
