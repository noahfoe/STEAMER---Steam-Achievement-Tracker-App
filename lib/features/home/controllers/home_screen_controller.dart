// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/features/games/screens/games_screen.dart';
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/models/games/game_details.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';
import 'package:steam_achievement_tracker/services/utils/logger.dart';
import 'package:steam_achievement_tracker/services/utils/preference_utils.dart';

class HomeScreenController extends GetxController with StateMixin<void> {
  final String steamID;

  final Database _database = Database.instance;

  HomeScreenController({required this.steamID}) {
    init();
  }

  final Rx<UserSteamInformation> playerSummary =
      UserSteamInformation.empty().obs;
  final Rx<List<Game>> playerGamesList = RxList<Game>.empty().obs;
  final Rx<List<GameDetails>> gameDetails = RxList<GameDetails>.empty().obs;
  final RxInt steamLevel = 0.obs;

  init() async {
    change(null, status: RxStatus.loading());
    try {
      getSharedPreferences();
      if (steamLevel.value == 0) {
        steamLevel.value = await _database.getSteamLevel(steamID: steamID);
        PreferenceUtils.setSteamLevel(steamLevel.value);
      }
      if (playerSummary.value == UserSteamInformation.empty()) {
        playerSummary.value =
            await _database.getPlayerSummary(steamID: steamID);
        PreferenceUtils.setPlayerSummary(playerSummary.value);
      }
      if (playerGamesList.value.isEmpty) {
        playerGamesList.value =
            await _database.getPlayerGamesList(steamID: steamID);
        PreferenceUtils.setPlayerGamesList(playerGamesList.value);
      }
      if (gameDetails.value.isEmpty) {
        gameDetails.value =
            await _database.getEveryOwnedGamesGameDetails(steamID: steamID);
        logger.i("outside function");
        logger.i(gameDetails.value);
        PreferenceUtils.setGameDetails(gameDetails.value);
      }
      update();
    } catch (e) {
      //logger.e(e);
      change(null, status: RxStatus.error(e.toString()));
    }
    change(null, status: RxStatus.success());
  }

  void getSharedPreferences() {
    steamLevel.value = PreferenceUtils.getSteamLevel();
    playerSummary.value = PreferenceUtils.getPlayerSummary();
    playerGamesList.value = PreferenceUtils.getPlayerGamesList().obs;
    gameDetails.value = PreferenceUtils.getGameDetails().obs;
    steamLevel.refresh();
    playerSummary.refresh();
    playerGamesList.refresh();
    gameDetails.refresh();
    logger.i("refreshed");
    logger.i("steamLevel: ${steamLevel.value}");
    logger.i("playerSummary: ${playerSummary.value}");
    logger.i("playerGamesList: ${playerGamesList.value}");
    logger.i("gameDetails: ${gameDetails.value}");
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
