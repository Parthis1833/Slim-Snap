import 'package:get_storage/get_storage.dart';

class UserPreferences {
  static final _otherBox = () => GetStorage('MyPref');
  final theme = ReadWriteValue('theme', 'light', _otherBox);
  final dirName = ReadWriteValue('dirName', 'KsReduce', _otherBox);
}
