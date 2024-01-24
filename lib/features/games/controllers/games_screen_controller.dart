// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';
import 'package:steam_achievement_tracker/services/utils/logger.dart';

class GamesScreenController extends GetxController with StateMixin<void> {
  final String steamID;

  Rx<List<Game>> playerGamesList = RxList<Game>.empty().obs;

  final Database _database = Database.instance;

  GamesScreenController({required this.steamID}) {
    init();
  }

  init() async {
    change(null, status: RxStatus.loading());
    try {
      playerGamesList = await _database.getPlayerGamesList(steamID);
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
