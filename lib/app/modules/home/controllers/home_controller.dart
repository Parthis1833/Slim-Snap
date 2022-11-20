import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_reducer/app/modules/home/controllers/image-compressor-controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  final mySite = "https://shyam-kachhadiya.web.app/";
  bool isDarkMode = false;
  final ImagePicker _picker = ImagePicker();
  File? image;
  String fileSize = "";
  var isImageSelected = false.obs;
  var isImageCompressed = false.obs;
  File? compressedFile;

  final userPref = GetStorage();
  bool isDirectoryGiven() {
    return userPref.read('directory') == null;
  }

  final imageCompressController = Get.put(ImageCompressController());
  String get directoryPath =>
      userPref.read('directory') ?? "Pictures/KS_Reduce";

  void choosenImage(XFile? image) async {
    if (image != null) {
      this.image = File(image.path);
      isImageSelected.value = false;
      isImageSelected.value = true;
      fileSize =
          "File Size: ${(this.image!.lengthSync() / 1024).toStringAsFixed(2)} KB or ${(this.image!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      isImageSelected.value = false;
      isImageCompressed.value = false;
      fileSize = "";
    }
    update();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    if (isDarkMode) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
    update();
  }

  void shareImage() {
    // Share.shareFiles(['${}/image.jpg'], text: 'Great picture');
    if (compressedFile?.path != null) {
      Share.shareXFiles([XFile(compressedFile!.path)],
          subject: "Compressed Image File");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void createFolder() async {
    final folderName = getUserDirectory();
    print(folderName);
    final path = Directory("storage/emulated/0/$folderName");
    if ((await path.exists())) {
    } else {
      path.create(recursive: true);
    }
  }

  // void createFolder() async {
  //   final folderName = getUserDirectory();

  //   final dir = Directory(
  //       '${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
  //               : await getApplicationSupportDirectory() //FOR IOS
  //           )!.path}/$folderName');
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   if ((await dir.exists())) {
  //     // return dir.path;
  //   } else {
  //     dir.create(recursive: true);
  //     // return dir.path;
  //   }
  // }

  Future<bool> compressFile(String outputFileName) async {
    if (this.image != null) {
      compressedFile = await imageCompressController.compressFile(
          this.image!, outputFileName);
      isImageCompressed.value = true;
      return true;
    }
    isImageCompressed.value = false;
    return false;
  }

  String getUserDirectory() {
    final folderName =
        isDirectoryGiven() ? userPref.read('directory') : directoryPath;
    return folderName;
  }

  void changeUserDirectory(String text) {
    text = "Pictures/" + text;
    userPref.write("directory", text);
    createFolder();
  }
}
