import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const cartBoxName = 'cart_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(cartBoxName);
  }

  static Box<Map> get cartBox => Hive.box<Map>(cartBoxName);
}
