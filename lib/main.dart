  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:slimsnap/app/modules/home/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';


void main() async {
  
  await GetStorage.init();

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

