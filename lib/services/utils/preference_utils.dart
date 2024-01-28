// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:steam_achievement_tracker/services/models/games/game.dart';
import 'package:steam_achievement_tracker/services/models/games/game_details.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static List<Game> getPlayerGamesList() {
    var temp = _prefsInstance!.getStringList('playerGamesList') ?? [];
    return temp
        .map((String e) => Game.fromSharedPrefs(json.decode(e)))
        .toList();
  }

  static Future<void> setPlayerGamesList(List<Game> value) async {
    await _prefsInstance!.setStringList(
        'playerGamesList', value.map((e) => e.toJson()).toList());
  }

  static int getSteamLevel() {
    return _prefsInstance!.getInt('steamLevel') ?? 0;
  }

  static Future<void> setSteamLevel(int value) async {
    await _prefsInstance!.setInt('steamLevel', value);
  }

  static List<GameDetails> getGameDetails() {
    try {
      var temp = _prefsInstance!.getStringList('gameDetails') ?? [];
      return temp
          .map((String e) => GameDetails.fromSharedPrefs(json.decode(e)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> setGameDetails(List<GameDetails> value) async {
    await _prefsInstance!
        .setStringList('gameDetails', value.map((e) => e.toJson()).toList());
  }

  static UserSteamInformation getPlayerSummary() {
    var temp = _prefsInstance!.getString('playerSummary') ??
        UserSteamInformation.empty().toJson();
    return UserSteamInformation.fromJson(temp);
  }

  static Future<void> setPlayerSummary(UserSteamInformation value) async {
    await _prefsInstance!.setString('playerSummary', value.toJson());
  }
}
