


//This class holds all the firebase storage functions
import 'package:cloud_firestore/cloud_firestore.dart';

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
    print("🖥️🖥️🖥️Error updating the Category: ${e.toString()}");
  }
}

//delete category
Future deleteCategory({required String docId})async{
  await db.collection("shop_categories").doc(docId).delete();
}

}