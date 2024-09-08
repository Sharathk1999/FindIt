// ignore_for_file: unnecessary_cast

import 'package:findit_admin_app/containers/confirm_widget.dart';
import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/models/promo_banners_model.dart';
import 'package:flutter/material.dart';

class PromoBannersPage extends StatefulWidget {
  const PromoBannersPage({super.key});

  @override
  State<PromoBannersPage> createState() => _PromoBannersPageState();
}

class _PromoBannersPageState extends State<PromoBannersPage> {
  bool _isInitialized = false;
  bool _isPromo = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!_isInitialized) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          if (arguments != null && arguments is Map<String, dynamic>) {
            _isPromo = arguments["promo"] ?? true;
          }
          debugPrint("promo $_isPromo");
          _isInitialized = true;
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isPromo ? "Promos" : "Banners",
        ),
      ),
      body: _isInitialized
          ? StreamBuilder(
              stream: DbService().readPromos(_isPromo),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PromoBannersModel> promos =
                      PromoBannersModel.fromJsonList(snapshot.data!.docs)
                          as List<PromoBannersModel>;
                  if (promos.isEmpty) {
                    return Center(
                      child:
                          Text("No ${_isPromo ? "Promos" : "Banners"} found"),
                    );
                  }
                  return ListView.builder(
                    itemCount: promos.length,
                    itemBuilder: (context, index) {  
                      return ListTile(
                        onTap: () {
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
                                       DbService().deletePromos( isPromo: _isPromo, id: promos[index].id);
                                   Navigator.pop(context);
                                    },
                                    onNo: () => Navigator.pop(context),
                                  );
                                },
                              );
                            },
                            child:  Text(
                              "Delete ${_isPromo ? "Promo":"Banner"}",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                               Navigator.pushNamed(context, "/update_promo",arguments: {
                              "promo":_isPromo,
                              "detail":promos[index],
                            });
                            
                            },
                            child:  Text(
                              "Update  ${_isPromo ? "Promo":"Banner"}",
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
                          child: Image.network(promos[index].image),
                        ),
                        title: Text(
                          promos[index].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          promos[index].category,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/update_promo",arguments: {
                              "promo":_isPromo,
                              "detail":promos[index],
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          : const SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/update_promo", arguments: {
            "promo": _isPromo,
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
