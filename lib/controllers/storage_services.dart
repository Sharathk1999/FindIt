import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //upload image to firebase storage
  Future<String?> uploadImage(String path, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
    const  SnackBar(
        content: Text(
          "Uploading image...",
        ),
      ),
    );
    debugPrint("Image Uploading....");
    File file = File(path);

    try {
      //unique file name based on current time
      String fileName = DateTime.now().toString();

      //reference for firebase storage
      Reference ref = _storage.ref().child("findIt_images/$fileName");

      //uploading file
      UploadTask uploadTask = ref.putFile(file);

      //wait for upload task
      await uploadTask;

      //get image download url
      String downloadUrl =  await ref.getDownloadURL();
      debugPrint("Download URL: $downloadUrl");
      return downloadUrl;

    } catch (e) {
     debugPrint("Error from StorageService: $e");
     return null; 
    }
  }
}
