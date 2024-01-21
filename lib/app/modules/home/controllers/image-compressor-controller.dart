import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:slimsnap/app/modules/home/controllers/home_controller.dart';
import 'package:slimsnap/app/modules/home/controllers/utilController.dart';

class ImageCompressController extends GetxController {
  final utilController = Get.put(UtilController());

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

  Future<XFile> compressFile(File file, String outputFileName) async {
    final homeController = Get.put(HomeController());
    final filePath = file.absolute.path;
    String outPath = '';
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    Directory generalDownloadDir = Directory('/storage/emulated/0/');
    if (utilController.isNotNullOrNotEmpty(outputFileName)) {
      outPath =
          "${generalDownloadDir.path}${homeController.directoryPath}/$outputFileName${filePath.substring(lastIndex)}";
    } else {
      outputFileName = "KS_Reduce${DateTime.now().microsecondsSinceEpoch}";
      outPath =
          "${generalDownloadDir.path}${homeController.directoryPath}/$outputFileName${filePath.substring(lastIndex)}";
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 5,
    );
    return result!;
  }
}
