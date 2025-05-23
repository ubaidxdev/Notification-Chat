import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestorageFuction {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    String url = "";
    try {
      final String id =
          DateTime.now().millisecondsSinceEpoch.toString() +
          file.path.split("/").last;
      final reference = _storage.ref().child("media/$id");
      await reference.putFile(file);
      url = await reference.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
    }
    return url;
  }

  Future<String> updatefile(String imageurl, File file) async {
    String url = "";
    try {
      final reference = _storage.refFromURL(imageurl);
      await reference.putFile(file);
      url = await reference.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
    }
    return url;
  }

  Future<void> deletefile(String imageurl) async {
    try {
      final reference = _storage.refFromURL(imageurl);
      await reference.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
