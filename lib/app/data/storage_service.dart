import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static StorageService get instance => _instance;

  late SharedPreferences _storage;

  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  String get adminUsername =>
      _storage.getString("adminUsername") ?? "admin@mail.com";

  set adminUsername(String username) {
    _storage.setString("adminUsername", username);
  }

  String get adminPassword => _storage.getString("adminPassword") ?? "password";

  set adminPassword(String password) {
    _storage.setString("adminPassword", password);
  }
}
