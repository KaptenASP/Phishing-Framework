import 'package:localstorage/localstorage.dart';

class Storage {
  // Allow only a single class to be instantiated.
  Storage._privateConstructor();
  static final Storage instance = Storage._privateConstructor();

  final LocalStorage storage = LocalStorage('phishing_framework_store');

  Map<String, dynamic>? loadFromStorage(String key) {
    dynamic data = storage.getItem(key);
    if (data == null) {
      print("NO DATA FOUND!");
      return null;
    }

    Map<String, dynamic> res = data;
    return res;
  }

  void saveToStorage(String key, Map<String, dynamic> data) {
    storage.setItem(key, data);
    print("SAVED!");
  }
}
