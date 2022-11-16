import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UtilController extends GetxController {
  var folderName = ''.obs;

  void setFolderName(String name) {
    this.folderName.value = name;
  }

  String getFolderName() {
    return this.folderName.value;
  }

  bool isNotNullOrNotEmpty(String name) {
    if (name.toString().isNotEmpty) {
      return true;
    }
    return false;
  }

  bool isBoolean(String name) {
    if (name == "true") {
      return true;
    }
    return false;
  }
}
