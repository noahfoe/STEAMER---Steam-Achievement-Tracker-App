// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/features/games/screens/games_screen.dart';
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';

class HomeScreenController extends GetxController with StateMixin<void> {
  final String steamID;

  final Rx<UserSteamInformation> playerSummary =
      UserSteamInformation.empty().obs;

  final Rx<List<Game>> playerGamesList = RxList<Game>.empty().obs;
  final Database _database = Database.instance;

  HomeScreenController({required this.steamID}) {
    init();
  }

  init() async {
    change(null, status: RxStatus.loading());
    try {
      playerSummary.value = await _database.getPlayerSummary(steamID);
      if (playerSummary.value == UserSteamInformation.empty()) {
        change(null, status: RxStatus.empty());
        return;
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
    change(null, status: RxStatus.success());
  }

  /// Navigate the user to the Games Screen.
  void navigateToGamesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamesScreen(
          steamID: steamID,
        ),
      ),
    );
  }
}
