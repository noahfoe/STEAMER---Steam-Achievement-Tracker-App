// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steam_achievement_tracker/features/games/screens/games_screen.dart';
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';
import 'package:steam_achievement_tracker/services/utils/database.dart';
import 'package:steam_achievement_tracker/services/utils/logger.dart';

class HomeScreenController extends GetxController {
  final String steamID;

  final Rx<UserSteamInformation> playerSummary =
      UserSteamInformation.empty().obs;

  final Rx<List<Game>> playerGamesList = RxList<Game>.empty().obs;
  final Database _database = Database.instance;

  HomeScreenController({required this.steamID}) {
    getPlayerSummary();
  }

  /// Gets the user's basic Steam information from the Steam API.
  void getPlayerSummary() async {
    final response = await http.get(
      Uri.parse(
        'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=${_database.steamApiKey}&steamids=$steamID',
      ),
    );
    playerSummary.value = UserSteamInformation.fromSteamAPI(
      json.decode(response.body)['response']['players'][0],
    );
    logger.i(playerSummary);
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
