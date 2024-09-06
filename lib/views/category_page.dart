import 'dart:io';

import 'package:findit_admin_app/containers/confirm_widget.dart';
import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/controllers/storage_services.dart';
import 'package:findit_admin_app/models/category_model.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<CategoryModel> categories =
              CategoryModel.fromJsonList(value.categories);
          if (value.categories.isEmpty) {
            return const Center(
              child: Text("Categories not found"),
            );
          }

          return ListView.builder(
            itemCount: value.categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    // ignore: unnecessary_null_comparison
                    categories[index].image == null ||
                            categories[index].image == ""
                        ? "https://icrier.org/wp-content/uploads/2022/09/Event-Image-Not-Found.jpg"
                        : categories[index].image,
                  ),
                ),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("What you want to do?"),
                        content: const Text("Cannot undo delete action.!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmWidget(
                                    contentText: "Are you sure you want to delete it.",
                                    onYes: () {
                                       DbService().deleteCategory(
                                  docId: value.categories[index].id);
                                   Navigator.pop(context);
                                    },
                                    onNo: () => Navigator.pop(context),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Delete Category",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => ModifyCategory(
                                  isUpdating: true,
                                  categoryId: value.categories[index].id,
                                  priority: categories[index].priority,
                                  image: categories[index].image,
                                  name: categories[index].name,
                                ),
                              );
                            },
                            child: const Text(
                              "Update Category",
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: Text(
                  categories[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Priority: ${categories[index].priority}"),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ModifyCategory(
                        isUpdating: true,
                        categoryId: value.categories[index].id,
                        priority: categories[index].priority,
                        image: categories[index].image,
                        name: categories[index].name,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_document,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ModifyCategory(
                isUpdating: false, categoryId: "", priority: 0),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory({
    super.key,
    required this.isUpdating,
    this.name,
    required this.categoryId,
    this.image,
    required this.priority,
  });

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  // ignore: avoid_init_to_null
  late XFile? image = null;

  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
    imageController.dispose();
    priorityController.dispose();
  }

  //func to pick image using image picker
  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await StorageServices().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("Set image url ${res} : ${imageController.text}");
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Update Category" : "Add Category"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("All will be converted to lowercase"),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: categoryController,
                validator: (value) =>
                    value!.isEmpty ? "This field can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  label: const Text("Category Name"),
                  fillColor: Colors.blue.withAlpha(35),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("This will be used in ordering categories"),
              TextFormField(
                controller: priorityController,
                validator: (value) =>
                    value!.isEmpty ? "This field can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Priority",
                  label: const Text("Priority"),
                  fillColor: Colors.blue.withAlpha(35),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              image == null
                  ? imageController.text.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(20),
                          height: 100,
                          width: double.infinity,
                          color: Colors.blueGrey.shade300,
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const SizedBox()
                  : Container(
                      margin: const EdgeInsets.all(20),
                      height: 200,
                      width: double.infinity,
                      color: Colors.blueGrey.shade300,
                      child: Image.file(
                        File(
                          image!.path,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
              ElevatedButton(
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
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              if (widget.isUpdating) {
                await DbService().updateCategory(
                  docId: widget.categoryId,
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Category Updated.",
                    ),
                  ),
                );
              } else {
                await DbService().createCategory(
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Category Added",
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            }
          },
          child: Text(
            widget.isUpdating ? "Update" : "Add New",
          ),
        ),
      ],
    );
  }
}
