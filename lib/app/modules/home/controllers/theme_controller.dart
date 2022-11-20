import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_reducer/app/modules/home/controllers/user_preferences.dart';
import 'package:image_reducer/app/modules/home/controllers/utilController.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  final themeStorage = GetStorage();
  final utilController = Get.put(UtilController());
  final userPref = GetStorage();
  bool get isDark => userPref.read('darkMode') ?? false;

  ThemeMode get theme =>
      isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    if (userPref.read('darkmode') ?? false) {
      Get.changeTheme(ThemeData.dark());
      userPref.write('darkMode', true);
    } else {
      Get.changeTheme(ThemeData.light());
      userPref.write('dartMode', false);
    }
    update();
  }

  
}
