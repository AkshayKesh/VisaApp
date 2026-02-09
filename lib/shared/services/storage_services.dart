import 'package:hive/hive.dart';
import 'package:register_visa_web_app/features/auth/domain/hive_user_model.dart';

class HiveService {
  static final _userBox = Hive.box<UserModel>('user');
  static final _settingsBox = Hive.box('settings');

  // ---------- User CRUD ----------

  static Future<void> addUser(UserModel user) async {
    await _userBox.put("user", user);
  }

  static UserModel? getUser(String token) {
    return _userBox.get(token);
  }

  static String? getUserToken() {
    final user = _userBox.get("user");

    return user?.token;
  }

  static String? getUserName() {
    final user = _userBox.get("user");
    return user?.name;
  }

  static String? getPhoneNumber() {
    final user = _userBox.get("user");
    return user?.phoneNumber;
  }

  static String? getEmail() {
    final user = _userBox.get("user");
    return user?.email;
  }

  static String? getProfile() {
    final user = _userBox.get("user");
    return user?.profilePic;
  }

  static Future<void> deleteUser() async {
    await _userBox.delete("user");
  }

  // ---------- Settings ----------

  static Future<void> setLogin(bool value) async {
    await _settingsBox.put('isLogin', value);
  }

  static bool isLogin() {
    return _settingsBox.get('isLogin', defaultValue: false);
  }

  static Future<void> clearAll() async {
    await Hive.deleteFromDisk();
  }
}
