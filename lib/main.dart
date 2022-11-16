
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_reducer/app/modules/home/controllers/home_controller.dart';
import 'package:image_reducer/app/modules/home/controllers/theme_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/routes/app_pages.dart';

void main() async {
  
  await GetStorage.init();
  getPermissions();
  final themeController = Get.put(ThemeController());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(
        GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          themeMode: themeController.theme,
          // theme: ThemeData.light(),
        ),
      );
    });
}

void getPermissions() async {
  final homeController = Get.put(HomeController());

  final status = await Permission.storage.request();
  var state = await Permission.manageExternalStorage.status;
  var state2 = await Permission.storage.status;


  if (status.isGranted) {
    homeController.createFolder();
  }
  if (!state2.isGranted) {
    await Permission.storage.request();
  }
  if (!state.isGranted) {
    await Permission.manageExternalStorage.request();
  }
}
