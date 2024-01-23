// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steam_achievement_tracker/services/models/games/game_details.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';
import 'package:steam_achievement_tracker/services/utils/logger.dart';

class GameDetailsScreenController extends GetxController with StateMixin<void> {
  final String steamID;
  final int appID;

  GameDetailsScreenController({required this.steamID, required this.appID}) {
    getGameInfoAndAchievements();
  }

  final Database _database = Database.instance;

  final Rx<GameDetails> gameDetails = GameDetails.empty().obs;
  final Rx<bool> isAchieved = false.obs;
  final Rx<GameDetails> unlockedAchievements = GameDetails.empty().obs;
  final Rx<GameDetails> lockedAchievements = GameDetails.empty().obs;

  void getGameInfoAndAchievements() async {
    change(null, status: RxStatus.loading());
    try {
      logger.i(
          'https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?key=${_database.steamApiKey}&appid=$appID&steamid=$steamID');
      // Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?key=${_database.steamApiKey}&appid=$appID&steamid=$steamID',
        ),
      );
      // Update gameDetails data object
      gameDetails.value = GameDetails.fromMap(
        json.decode(response.body),
      );
      getUnlockedAchievements();
    } catch (e) {
      logger.e(e);
      change(null, status: RxStatus.error(e.toString()));
    }
    change(null, status: RxStatus.success());
  }

  void getUnlockedAchievements() async {
    change(null, status: RxStatus.loading());
    try {
      // Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?key=${_database.steamApiKey}&appid=$appID&steamid=$steamID',
        ),
      );

      final body = json.decode(response.body)['playerstats']['achievements'];

      if (body != null && body != []) {
        // Update the current achievements 'achieved' value
        gameDetails.value = gameDetails.value.copyWith(
          achievements: gameDetails.value.achievements!
              .map(
                (e) => e.copyWith(
                    achieved: body.firstWhere(
                          (element) => element['apiname'] == e.name,
                          orElse: () => null,
                        )['achieved'] ??
                        0),
              )
              .toList(),
        );

        // Sort list so that achieved achievements are at the top
        gameDetails.value.achievements!.sort(
          (a, b) => b.achieved.compareTo(a.achieved),
        );

        // Split list into unlocked and locked
        unlockedAchievements.value = gameDetails.value.copyWith(
          achievements: gameDetails.value.achievements!
              .where((element) => element.achieved == 1)
              .toList(),
        );

        lockedAchievements.value = gameDetails.value.copyWith(
          achievements: gameDetails.value.achievements!
              .where((element) => element.achieved == 0)
              .toList(),
        );
      }
    } catch (e) {
      logger.e(e);
      change(null, status: RxStatus.error(e.toString()));
    }
    change(null, status: RxStatus.success());
  }
}
