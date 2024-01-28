// ignore_for_file: depend_on_referenced_packages, invalid_use_of_protected_member

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/models/games/game_details.dart';
import 'package:steam_achievement_tracker/services/models/games/global_achievement_percentages.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';

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

  /// Gets the Steam API key from the server.
  Future<void> getSteamApiKey() async {
    try {
      // Get response to get the api key from the server
      final response = await http.get(Uri.parse('http://192.168.0.195:8080'));

      // Parse the response and set the api key
      steamApiKey = json.decode(response.body)['steamApiKey'];
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the user's basic Steam information from the Steam API.
  Future<UserSteamInformation> getPlayerSummary(
      {required String steamID}) async {
    try {
      /// Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$steamApiKey&steamids=$steamID',
        ),
      );

      // Parse data into data object classes
      UserSteamInformation temp = UserSteamInformation.fromSteamAPI(
        json.decode(response.body)['response']['players'][0],
      );

      /// Return the data object
      return temp;
    } catch (e) {
      rethrow;
    }
  }

  Future<RxList<GlobalAchievementPercentages>>
      getGlobalAchievementPercentagesForApp({required int appID}) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/?gameid=$appID',
        ),
      );
      List<GlobalAchievementPercentages> temp = [];
      Map<String, dynamic> body = json.decode(response.body);
      List achievements = body['achievementpercentages']['achievements'];
      for (var element in achievements) {
        temp.add(GlobalAchievementPercentages.fromMap(element));
      }
      return temp.obs;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the user's games list from the Steam API.
  Future<RxList<Game>> getPlayerGamesList({required String steamID}) async {
    try {
      // Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$steamApiKey&steamid=$steamID&format=json&include_appinfo=true&include_played_free_games=true',
        ),
      );

      // Parse response into a map (for code readability)
      Map<String, dynamic>? body = json.decode(response.body);

      // If there is no response, return an empty list
      if (body == null || body.isEmpty) return List<Game>.empty().obs;

      // If there are no games, return an empty list
      if (body['response']['games'] == null ||
          body['response']['games'] == []) {
        return List<Game>.empty().obs;
      }

      // Create a temporary list to store the data
      RxList<Game> temp = RxList<Game>.empty();

      // Loop through the data
      for (int i = 0; i < body['response']['games'].length; i++) {
        // Parse data into data object classes and add to the list
        temp.add(
          Game.fromMap(
            body['response']['games'][i],
          ),
        );
      }
      // Return the data object
      return temp;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GameDetails>> getEveryOwnedGamesGameDetails(
      {required String steamID}) async {
    // Get all games and their appID's
    final RxList<Game> games = await getPlayerGamesList(steamID: steamID);
    // Create a temporary list to store the data
    RxList<GameDetails> temp = RxList<GameDetails>.empty();

    // Loop through the games, getting their details
    int i = 0;
    for (var game in games) {
      temp.add(await getGameDetails(steamID: steamID, appID: game.appId));
      temp.value[i] = temp.value[i].copyWith(
        gameName: games.value[i].name,
      );
      // Update name while we are here
      i++;
    }

    // Return the data object
    return temp;
  }

  /// Gets a single GameDetails object from the Steam API.
  ///
  /// This function also calls [getAchievements] to get the user's achievements for the game.
  /// Which is then added to the GameDetails object.
  Future<GameDetails> getGameDetails(
      {required String steamID, required int appID}) async {
    try {
      // Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?key=$steamApiKey&appid=$appID&steamid=$steamID',
        ),
      );

      // Parse response into a map (for code readability)
      Map<String, dynamic>? body = json.decode(response.body);

      // If there is no response, return an empty list
      if (body == null || body.isEmpty) return GameDetails.empty();

      Rx<GameDetails> temp = GameDetails.fromMap(body).obs;

      // Get achievements
      temp = await getAchievements(
            gameDetails: temp,
            steamID: steamID,
            appID: appID,
          ) ??
          temp;

      // Parse data into data object classes and return it
      return temp.value;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the user's achievements for a specific game from the Steam API.
  Future<Rx<GameDetails>?> getAchievements({
    required Rx<GameDetails> gameDetails,
    required String steamID,
    required int appID,
  }) async {
    try {
      // Get response from Steam API
      final response = await http.get(
        Uri.parse(
          'http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?key=$steamApiKey&appid=$appID&steamid=$steamID',
        ),
      );

      // Parse response into a list of achievements (for code readability)
      final List? body =
          json.decode(response.body)['playerstats']['achievements'];

      // If there is no response, return
      if (body == null || body.isEmpty || body == []) return null;

      // Update the current achievements 'achieved' value
      gameDetails.value = gameDetails.value.copyWith(
        allAchievements: gameDetails.value.allAchievements!
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
      gameDetails.value.allAchievements!.sort(
        (a, b) => b.achieved.compareTo(a.achieved),
      );

      // Unlocked
      gameDetails.value = gameDetails.value.copyWith(
        unlockedAchievements: gameDetails.value.allAchievements!
            .where((element) => element.achieved == 1)
            .toList(),
      );

      // Locked
      gameDetails.value = gameDetails.value.copyWith(
        lockedAchievements: gameDetails.value.allAchievements!
            .where((element) => element.achieved == 0)
            .toList(),
      );
      return gameDetails;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSteamLevel({required String steamID}) {
    try {
      return http
          .get(
            Uri.parse(
              'http://api.steampowered.com/IPlayerService/GetSteamLevel/v1/?key=$steamApiKey&steamid=$steamID',
            ),
          )
          .then((value) => json.decode(value.body)['response']['player_level']);
    } catch (e) {
      rethrow;
    }
  }
}
