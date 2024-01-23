// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';
import 'package:steam_achievement_tracker/services/utils/logger.dart';

class GamesScreenController extends GetxController with StateMixin<void> {
  final String steamID;

  final Rx<List<Game>> playerGamesList = RxList<Game>.empty().obs;

  final Database _database = Database.instance;

  GamesScreenController({required this.steamID}) {
    getPlayerGamesList();
  }

  /// Gets the user's list of games in their Steam library from the Steam API.
  void getPlayerGamesList() async {
    change(null, status: RxStatus.loading());
    try {
      // Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=${_database.steamApiKey}&steamid=$steamID&format=json&include_appinfo=true&include_played_free_games=true',
        ),
      );
      // Parse data into data object classes
      for (int i = 0;
          i < json.decode(response.body)['response']['games'].length;
          i++) {
        playerGamesList.value.add(
          Game.fromMap(
            json.decode(response.body)['response']['games'][i],
          ),
        );
      }
    } catch (e) {
      logger.e(e);
      change(null, status: RxStatus.error(e.toString()));
    }
    change(null, status: RxStatus.success());
  }
}
