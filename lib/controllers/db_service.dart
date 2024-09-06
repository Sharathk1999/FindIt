


//This class holds all the firebase storage functions
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DbService {
  final db = FirebaseFirestore.instance;

  //Categories

//read category from db
Stream<QuerySnapshot> readCategories(){
  return db.collection("shop_categories").orderBy("priority", descending: true)
  .snapshots();
}

//create category
Future createCategory({required Map<String, dynamic> data})async{
  await db.collection("shop_categories").add(data);
}

//update category
Future updateCategory({required String docId, required Map<String, dynamic> data})async{
  try {
    if (docId.isEmpty) {
    throw ArgumentError('Document ID cannot be empty');
  }

    await db.collection("shop_categories").doc(docId).update(data);
  } catch (e) {
    debugPrint("🖥️🖥️🖥️Error updating the Category: ${e.toString()}");
  }
}

//delete category
Future deleteCategory({required String docId})async{
  await db.collection("shop_categories").doc(docId).delete();
}

//Products
//read products from db
Stream<QuerySnapshot> readProducts(){
  return db.collection("shop_products").orderBy("category", descending: true)
  .snapshots();
}

//create product
Future createProduct({required Map<String, dynamic> data})async{
  await db.collection("shop_products").add(data);
}

//update product
Future updateProduct({required String docId, required Map<String, dynamic> data})async{
  try {
    if (docId.isEmpty) {
    throw ArgumentError('Document ID cannot be empty');
  }

    await db.collection("shop_products").doc(docId).update(data);
  } catch (e) {
    debugPrint("🖥️🖥️🖥️Error updating the products: ${e.toString()}");
  }
}

//delete category
Future deleteProduct({required String docId})async{
  await db.collection("shop_products").doc(docId).delete();
}

}