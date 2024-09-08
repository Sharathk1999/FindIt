import 'package:findit_admin_app/containers/confirm_widget.dart';
import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/models/products_model.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:findit_admin_app/views/modify_product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<ProductsModel> products =
              // ignore: unnecessary_cast
              ProductsModel.fromJsonList(value.products) as List<ProductsModel>;
          if (products.isEmpty) {
            return const Center(
              child: Text("No Products Found."),
            );
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  "/view_product",
                  arguments: products[index],
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
                                    contentText:
                                        "Are you sure you want to delete this product.",
                                    onYes: () {
                                      DbService().deleteProduct(
                                          docId: products[index].id);
                                      Navigator.pop(context);
                                    },
                                    onNo: () => Navigator.pop(context),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Delete Product",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) =>const ModifyProductPage());
                            },
                            child: const Text(
                              "Edit Product",
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    products[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  products[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "₹ ${formatPrice(products[index].newPrice.toString())}"),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.lightBlue,
                          )),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        products[index].category.toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/add_product",
                        arguments: products[index]);
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
          Navigator.pushNamed(context, "/add_product");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

String formatPrice(String price) {
  final regex = RegExp(r'(\d+)(\d{3})');
  String formattedPrice = price;
  while (regex.hasMatch(formattedPrice)) {
    formattedPrice = formattedPrice.replaceAllMapped(
        regex, (match) => '${match.group(1)},${match.group(2)}');
  }
  return formattedPrice;
}
