import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _preferences;
  // init
  static Future<SharedPreferences> init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  //store data
  static Future<void> storeData({
    required String key,
    required dynamic value,
  }) async {
    // log("CHeck datatype : ${value.runtimeType}");
    switch (value.runtimeType) {
      case String:
        await _preferences.setString(key, value);
        break;
      case int:
        await _preferences.setInt(key, value);
        break;
      case double:
        await _preferences.setDouble(key, value);
        break;
      case bool:
        await _preferences.setBool(key, value);
        break;
      default:
        await _preferences.setStringList(key, value);
        break;
    }
  }

  // get data
  static String getStringData({required String key}) =>
      _preferences.getString(key) ?? "";
  static int getIntData({required String key}) => _preferences.getInt(key) ?? 0;
  static double getDoubleData({required String key}) =>
      _preferences.getDouble(key) ?? 0;
  static bool getBoolData({required String key}) =>
      _preferences.getBool(key) ?? false;

  // clear data
  static void clearData() {
    _preferences.clear();
  }

  // remove data
  static void removeData({
    required String key,
  }) {
    _preferences.remove(key);
  }
}
