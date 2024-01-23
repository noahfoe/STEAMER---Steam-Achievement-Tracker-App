// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steam_achievement_tracker/services/utils/logger.dart';

class Database extends GetxController {
  static Database instance = Get.put(_instance);
  static final _instance = Database._internal();
  Database._internal();

  @override
  void onInit() {
    super.onInit();
    getSteamApiKey();
  }

  String steamApiKey = '';

  Future<void> getSteamApiKey() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.195:8080'));
      steamApiKey = json.decode(response.body)['steamApiKey'];
    } catch (e) {
      logger.e(e);
    }
  }
}
