import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late GetStorage _storage;

  Future<StorageService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }

  bool get isDarkMode => _storage.read('isDarkMode') ?? false;
  set isDarkMode(value) => _storage.write('isDarkMode', value);

  final _isSubscribeToTopicKey = "isSubscribeToTopicKey";

  bool get isSubscribedToTopic =>
      _storage.read(_isSubscribeToTopicKey) ?? false;

  void setSubscribeToTopic() => _storage.write(_isSubscribeToTopicKey, true);
}
