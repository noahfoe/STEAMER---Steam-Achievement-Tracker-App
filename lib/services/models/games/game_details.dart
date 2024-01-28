// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:steam_achievement_tracker/services/models/games/achievement.dart';

class GameDetails extends Equatable {
  final String? gameName;
  final String? gameVersion;
  final List<Achievement>? allAchievements;
  final List<Achievement>? unlockedAchievements;
  final List<Achievement>? lockedAchievements;
  const GameDetails({
    required this.gameName,
    required this.gameVersion,
    this.allAchievements,
    this.unlockedAchievements,
    this.lockedAchievements,
  });

  GameDetails copyWith({
    String? gameName,
    String? gameVersion,
    List<Achievement>? allAchievements,
    List<Achievement>? unlockedAchievements,
    List<Achievement>? lockedAchievements,
  }) {
    return GameDetails(
      gameName: gameName ?? this.gameName,
      gameVersion: gameVersion ?? this.gameVersion,
      allAchievements: allAchievements ?? this.allAchievements,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      lockedAchievements: lockedAchievements ?? this.lockedAchievements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gameName': gameName ?? '',
      'gameVersion': gameVersion ?? '',
      'allAchievements': allAchievements?.map((x) => x.toMap()).toList() ?? [],
      'unlockedAchievements':
          unlockedAchievements?.map((x) => x.toMap()).toList() ?? [],
      'lockedAchievements':
          lockedAchievements?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory GameDetails.empty() {
    return const GameDetails(
      gameName: '',
      gameVersion: '',
      allAchievements: [],
    );
  }

  factory GameDetails.fromMap(Map<String, dynamic> map) {
    if (map['game'] == {}) return GameDetails.empty();
    map = map['game'];
    return GameDetails(
      gameName: map['gameName'] != null ? map['gameName'] as String : 'N/A',
      gameVersion:
          map['gameVersion'] != null ? map['gameVersion'] as String : 'N/A',
      allAchievements: map['availableGameStats'] != null
          ? map['availableGameStats']['achievements'] != null
              ? List<Achievement>.from(
                  (map['availableGameStats']['achievements'] as List<dynamic>)
                      .map<Achievement?>(
                    (x) => Achievement.fromMap(x as Map<String, dynamic>),
                  ),
                )
              : const []
          : const [],
      unlockedAchievements: const [],
      lockedAchievements: const [],
    );
  }

  factory GameDetails.fromSharedPrefs(Map<String, dynamic> map) {
    return GameDetails(
      gameName: map['gameName'] as String,
      gameVersion: map['gameVersion'] as String,
      allAchievements: map['allAchievements'] != []
          ? (map['allAchievements'] as List<dynamic>)
              .map((item) => Achievement.fromSharedPrefs(item))
              .toList()
          : [],
      unlockedAchievements: map['unlockedAchievements'] != []
          ? (map['unlockedAchievements'] as List<dynamic>)
              .map((item) => Achievement.fromSharedPrefs(item))
              .toList()
          : [],
      lockedAchievements: map['lockedAchievements'] != []
          ? (map['lockedAchievements'] as List<dynamic>)
              .map((item) => Achievement.fromSharedPrefs(item))
              .toList()
          : [],
    );
  }

  /* 
  
  'gameName': gameName ?? '',
      'gameVersion': gameVersion ?? '',
      'allAchievements': allAchievements?.map((x) => x.toMap()).toList() ?? [],
      'unlockedAchievements':
          unlockedAchievements?.map((x) => x.toMap()).toList() ?? [],
      'lockedAchievements':
          lockedAchievements?.map((x) => x.toMap()).toList() ?? [],
          
   */

  String toJson() => json.encode(toMap());

  factory GameDetails.fromJson(String source) =>
      GameDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      gameName ?? 'N/A',
      gameVersion ?? 'N/A',
      allAchievements ?? const [],
      unlockedAchievements ?? const [],
      lockedAchievements ?? const [],
    ];
  }
}
