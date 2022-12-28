import 'dart:core';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class StorageManager {
  final _box = Get.find<GetStorage>();

  void write(String name, dynamic value) {
    _box.write(name, value);
  }

  void delete(String name) {
    _box.remove(name);
  }

  dynamic get(String name) {
    return _box.read(name);
  }

  bool has(String name) {
    return _box.hasData(name);
  }

  String encodeList<T>(List<T> datas) {
    return json.encode(datas);
  }
}
