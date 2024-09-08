import 'package:findit_admin_app/containers/confirm_widget.dart';
import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/models/coupon_model.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupons Page"),
      ),
      body: StreamBuilder(
        stream: DbService().readCouponCode(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> coupons =
                CouponModel.fromJsonList(snapshot.data!.docs)
                    as List<CouponModel>;
            if (coupons.isEmpty) {
              return const Center(
                child: Text("No coupons found"),
              );
            } else {
              return ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("What you want to do?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmWidget(
                                        contentText:
                                            "Are you sure you want to delete it.",
                                        onYes: () {
                                          DbService().deleteCouponsCode(
                                              id: coupons[index].id);
                                          Navigator.pop(context);
                                        },
                                        onNo: () => Navigator.pop(context),
                                      );
                                    },
                                  );
                                },
                                child:const Text(
                                  "Delete Coupon",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => ModifyCoupon(
                                      id: coupons[index].id,
                                      code: coupons[index].code,
                                      description: coupons[index].description,
                                      discount: coupons[index].discount,
                                    ),
                                  );
                                },
                                child:const Text(
                                  "Update Coupon",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    title: Text(coupons[index].code),
                    subtitle: Text(coupons[index].description),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ModifyCoupon(
                            id: coupons[index].id,
                            code: coupons[index].code,
                            description: coupons[index].description,
                            discount: coupons[index].discount,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ModifyCoupon(
              id: "",
              code: "",
              description: "",
              discount: 0,
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}

class ModifyCoupon extends StatefulWidget {
  final String id, code, description;
  final int discount;
  const ModifyCoupon({
    super.key,
    required this.id,
    required this.code,
    required this.description,
    required this.discount,
  });

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();

  TextEditingController codeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountPercentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeController.text = widget.code;
    descriptionController.text = widget.description;
    discountPercentController.text = widget.discount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.id.isNotEmpty ? "Update Coupon" : "Add Coupon"),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("All will be converted to Uppercase"),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: codeController,
              validator: (value) =>
                  value!.isEmpty ? "This field can't be empty" : null,
              decoration: InputDecoration(
                hintText: "Coupon Code",
                label: const Text("Coupon Code"),
                fillColor: Colors.blue.withAlpha(35),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: descriptionController,
              validator: (value) =>
                  value!.isEmpty ? "This field can't be empty" : null,
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
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: discountPercentController,
              validator: (value) =>
                  value!.isEmpty ? "This field can't be empty" : null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Discount Percentage",
                label: const Text("Discount Percentage"),
                fillColor: Colors.blue.withAlpha(35),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
          ),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              var data = {
                "code": codeController.text.toUpperCase(),
                "description": descriptionController.text,
                "discount": int.parse(discountPercentController.text),
              };
              if (widget.id.isNotEmpty) {
                DbService().updateCouponsCode(id: widget.id, data: data);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Coupon code updated.",
                    ),
                  ),
                );
              } else {
                DbService().createCouponCode(data: data);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Coupon code added.",
                    ),
                  ),
                );
              }
            }
            Navigator.pop(context);
          },
          child: Text(
            widget.id.isNotEmpty ? "Update Coupon" : "Add Coupon",
          ),
        ),
      ],
    );
  }
}
