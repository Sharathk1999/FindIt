import 'dart:io';

import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/controllers/storage_services.dart';
import 'package:findit_admin_app/models/products_model.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProductPage extends StatefulWidget {
  const ModifyProductPage({super.key});

  @override
  State<ModifyProductPage> createState() => _ModifyProductPageState();
}

class _ModifyProductPageState extends State<ModifyProductPage> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  // ignore: avoid_init_to_null
  late XFile? image = null;
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();

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
  setData(ProductsModel data){
   productId = data.id;
   nameController.text = data.name;
   oldPriceController.text = data.oldPrice.toString();
   newPriceController.text = data.newPrice.toString();
   quantityController.text = data.maxQuantity.toString();
   categoryController.text = data.category;
   descriptionController.text = data.description;
   imageController.text = data.image;
   setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    oldPriceController.dispose();
    newPriceController.dispose();
    quantityController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    imageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ProductsModel) {
      setData(arguments);
    }
    return Scaffold(
      appBar: AppBar(
        title:  Text(productId.isNotEmpty ? "Update Product":"Add Product"),
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
                  controller: nameController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                      hintText: "Product Name",
                      label: const Text("Product Name"),
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
                  controller: oldPriceController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                      hintText: "Original Price",
                      label: const Text("Original Price"),
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
                  controller: newPriceController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                      hintText: "Selling Price",
                      label: const Text("Selling Price"),
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
                  controller: quantityController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                      hintText: "Quantity Left",
                      label: const Text("Quantity Left"),
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
                TextFormField(
                  controller: descriptionController,
                  validator: (value) =>
                      value!.isEmpty ? "This field can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Description",
                    label: const Text("Description"),
                    fillColor: Colors.blue.withAlpha(35),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 8,
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
                    backgroundColor: WidgetStatePropertyAll(Colors.blue.shade100),
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
              const  SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {
                      "name":nameController.text,
                      "oldPrice":int.parse(oldPriceController.text),
                      "newPrice":int.parse(newPriceController.text),
                      "quantity":int.parse(quantityController.text),
                      "category":categoryController.text,
                      "description":descriptionController.text,
                      "image":imageController.text,
                    };
                    if (productId.isNotEmpty) {
                      
                       DbService().updateProduct(data: data,docId: productId);
                       Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Product Updated.",
                    ),
                  ),
                );
                    }else{
                    DbService().createProduct(data: data);
                    Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Product Created.",
                    ),
                  ),
                );
                    }

                  }
                }, child: Text(productId.isNotEmpty ? "Update Product":"Add Product"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
