
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'auth_service.dart';

class FileService {
  static final storage = FirebaseStorage.instance.ref();
  static const folderUser = 'userImages';
  static const folderPost = 'userImages';

  static Future<String> uploadUserImage(File image) async{
    String uid = AuthService.currentUserId();
    String imgName = uid;
    var firebaseStorageRef = storage.child(folderUser).child(imgName);
    var uploadTask = firebaseStorageRef.putFile(image, SettableMetadata( contentType: 'image/jpeg'));
    await uploadTask.whenComplete(() {});
    final String downloadUrl = await firebaseStorageRef.getDownloadURL();
    if (kDebugMode) {
      print(downloadUrl);
    }
    return downloadUrl;
  }

  static Future<String> uploadPostImage(File image) async{
    String uid = AuthService.currentUserId();
    String imgName = '${uid}_${DateTime.now()}';
    var firebaseStorageRef = storage.child(folderPost).child(imgName);
    var uploadTask = firebaseStorageRef.putFile(image, SettableMetadata( contentType: 'image/jpeg'));
    await uploadTask.whenComplete(() {});
    final String downloadUrl = await firebaseStorageRef.getDownloadURL();
    if (kDebugMode) {
      print(downloadUrl);
    }
    return downloadUrl;
  }
}