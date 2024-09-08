import 'dart:io';

import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/controllers/storage_services.dart';
import 'package:findit_admin_app/models/promo_banners_model.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyPromo extends StatefulWidget {
  const ModifyPromo({super.key});

  @override
  State<ModifyPromo> createState() => _ModifyPromoState();
}

class _ModifyPromoState extends State<ModifyPromo> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  // ignore: avoid_init_to_null
  late XFile? image = null;
  bool _isInitialized = false;
  // ignore: unused_field
  bool _isPromo = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!_isInitialized) {
          final arguments = ModalRoute.of(context)!.settings.arguments;
          if (arguments != null && arguments is Map<String, dynamic>) {
            if (arguments["detail"] is PromoBannersModel) {
              setData(arguments["detail"] as PromoBannersModel);
            }
            _isPromo = arguments["promo"] ?? true;
            setState(() {});
          }
          _isInitialized = true;
        }
      },
    );
  }
  //func to pick image using image picker
  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await StorageServices().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          imageController.text = res;
          debugPrint("Set image url $res : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Image uploaded successful.",
              ),
            ),
          );
        }
      });
    }
  }

//set the data from arguments for updating the product
  setData(PromoBannersModel data) {
    productId = data.id;
    titleController.text = data.title;
    categoryController.text = data.category;
    imageController.text = data.image;
    setState(() {});
  }


  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    categoryController.dispose();
    imageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productId.isNotEmpty
            ? _isPromo
                ? "Update Promo"
                : "Update Banner"
            : _isPromo
                ? "Add Promo"
                : "Add Banner"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                      hintText: "Title",
                      label: const Text("Title"),
                      fillColor: Colors.blue.withAlpha(35),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Category",
                      label: const Text("Category"),
                      fillColor: Colors.blue.withAlpha(35),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Select Category: "),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Consumer<AdminProvider>(
                                builder: (context, value, child) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: value.categories
                                          .map(
                                            (e) => TextButton(
                                              onPressed: () {
                                                categoryController.text =
                                                    e["name"];
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                e["name"],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                image == null
                    ? imageController.text.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(),
                              color: Colors.blueGrey.shade100,
                            ),
                            margin: const EdgeInsets.all(20),
                            height: 100,
                            width: double.infinity,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueGrey),
                          color: const Color.fromARGB(255, 192, 218, 239),
                        ),
                        margin: const EdgeInsets.all(20),
                        height: 200,
                        width: double.infinity,
                        // color: Colors.blueGrey.shade300,
                        child: Image.file(
                          File(
                            image!.path,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.blue.shade100),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text(
                    "Pick Image",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: imageController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                      hintText: "Image Link",
                      label: const Text("Image Link"),
                      fillColor: Colors.blue.withAlpha(35),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> data = {
                        "title": titleController.text,
                        "category": categoryController.text,
                        "image": imageController.text,
                      };
                      if (productId.isNotEmpty) {
                        DbService().updatePromos(data: data, id: productId,isPromo: _isPromo,);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(
                              "${_isPromo? "Promo" :"Banner"} Updated.",
                            ),
                          ),
                        );
                      } else {
                        DbService().createPromos(data: data,isPromo: _isPromo);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(
                              "${_isPromo? "Promo" :"Banner"} Created.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(productId.isNotEmpty
            ? _isPromo
                ? "Update Promo"
                : "Update Banner"
            : _isPromo
                ? "Add Promo"
                : "Add Banner"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
