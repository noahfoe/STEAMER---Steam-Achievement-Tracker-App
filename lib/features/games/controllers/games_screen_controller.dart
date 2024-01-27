// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';
import 'package:steam_achievement_tracker/services/utils/logger.dart';

class GamesScreenController extends GetxController with StateMixin<void> {
  final String steamID;

  Rx<List<Game>> playerGamesList = RxList<Game>.empty().obs;
  Rx<List<Game>> filteredGamesList = RxList<Game>.empty().obs;

  final Database _database = Database.instance;
  final TextEditingController searchController = TextEditingController();

  GamesScreenController({required this.steamID}) {
    init();
  }

  searchGamesList(String value) {
    if (value.isEmpty) {
      filteredGamesList.value = playerGamesList.value;
      return;
    }
    filteredGamesList.value = playerGamesList.value
        .where((Game element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList()
        .obs;
  }

  init() async {
    change(null, status: RxStatus.loading());
    try {
      playerGamesList = await _database.getPlayerGamesList(steamID: steamID);
      filteredGamesList.value = playerGamesList.value;
      if (playerGamesList.value.isEmpty) {
        change(null, status: RxStatus.empty());
        return;
      }
    } catch (e) {
      logger.e(e);
      change(null, status: RxStatus.error(e.toString()));
    }
    change(null, status: RxStatus.success());
  }
}
