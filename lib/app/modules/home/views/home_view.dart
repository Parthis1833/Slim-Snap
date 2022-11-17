import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends GetView<HomeController> {
  final ImagePicker _picker = ImagePicker();
  final outputFileNameController = TextEditingController();
  final folderNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KS Reducer'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 0:
                  _selectImageFromCamera();
                  break;
                case 1:
                  _chooseFolderName();
                  break;
                case 3:
                  _aboutUs();
                  break;
                default:
                  throw UnimplementedError();
              }
            },
            icon: const Icon(
                Icons.menu), //don't specify icon if you want 3 dot menu
            color: Colors.blue,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                onTap: () {},
                value: 0,
                child: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem<int>(
                onTap: _chooseFolderName,
                value: 1,
                child: const Text(
                  "Folder Name",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem<int>(
                onTap: () => controller.toggleDarkMode(),
                value: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Toggle Theme",
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        controller.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text(
                  "About us",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(() => controller.isImageSelected.value
              ? _imageWidget()
              : const SizedBox(
                  height: 200,
                  width: 200,
                )),
          ElevatedButton(
            onPressed: _selectImage,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Choose Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Obx(() => controller.isImageSelected.value
              ? ElevatedButton(
                  onPressed: _getxDialogMenuFileName,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Compress Image",
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
              : const SizedBox()),
          Obx((() => controller.isImageCompressed.value
              ? _shareImageWidget()
              : const SizedBox())),
        ],
      )),
    );
  }

  Widget _shareImageWidget() {

    return Center(
        child: Column(
      children: [
        IconButton(
          iconSize: 80,
          onPressed: controller.shareImage,
          icon: const Icon(Icons.share),
        ),
        Text(
            "Compressed Image Location is \n ${controller.compressedFile!.path}"),
        Text(
            "New Compressed Image Size is ${(controller.compressedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB")
      ],
    ));
  }

  Widget _imageWidget() {
    return ListTile(
      title: Image.file(
        width: 200,
        height: 200,
        controller.image!,
        key: UniqueKey(),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Text(controller.fileSize),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    imageCache.clear();
    imageCache.clearLiveImages();

    var image = await _picker.pickImage(source: ImageSource.gallery);
    controller.choosenImage(image);
  }

  Future<void> _selectImageFromCamera() async {
    imageCache.clear();
    imageCache.clearLiveImages();

    var image = await _picker.pickImage(source: ImageSource.camera);
    controller.choosenImage(image);
  }

  void _getxDialogMenuFileName() {
    Get.defaultDialog(
        title: 'File Name for compressed object',
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        content: Container(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: outputFileNameController,
                  onSubmitted: (value) {
                    controller.compressFile(outputFileNameController.text);
                    Get.back();
                  },
                  onChanged: (value) {
                    //Do something with the user input.
                  },
                  decoration: const InputDecoration(
                    hintText: 'image name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    controller.compressFile(outputFileNameController.text);
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  )),
            ],
          ),
        ));
  }

  void _chooseFolderName() {
    Get.defaultDialog(
        onCancel: () {
          print("hii");
        },
        title: 'Folder Name to save compressed files',
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        content: Container(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: folderNameController,
                  onSubmitted: (value) {
                    controller.changeUserDirectory(folderNameController.text);
                    Get.back();
                  },
                  onChanged: (value) {
                    //Do something with the user input.
                  },
                  decoration: const InputDecoration(
                    hintText: 'KS',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    // controller.compressFile(outputFileNameController.text);
                    controller.changeUserDirectory(folderNameController.text);
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  )),
            ],
          ),
        ));
  }

  void _aboutUs() async {
    if (await canLaunchUrl(Uri.parse(controller.mySite))) {
      await launchUrl(Uri.parse(controller.mySite));
    } else
      // can't launch url, there is some error
      throw "Could not launch $controller.mySite";
  }
}
