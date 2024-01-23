// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:steam_achievement_tracker/services/models/games/achievement.dart';

class GameDetails extends Equatable {
  final String? gameName;
  final String? gameVersion;
  final List<Achievement>? achievements;
  const GameDetails({
    required this.gameName,
    required this.gameVersion,
    this.achievements,
  });

  GameDetails copyWith({
    String? gameName,
    String? gameVersion,
    List<Achievement>? achievements,
  }) {
    return GameDetails(
      gameName: gameName ?? this.gameName,
      gameVersion: gameVersion ?? this.gameVersion,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gameName': gameName,
      'gameVersion': gameVersion,
      'achievements': achievements != null
          ? achievements!.map((x) => x.toMap()).toList()
          : [],
    };
  }

  factory GameDetails.empty() {
    return const GameDetails(
      gameName: '',
      gameVersion: '',
      achievements: [],
    );
  }

  factory GameDetails.fromMap(Map<String, dynamic> map) {
    if (map['game'] == {}) return GameDetails.empty();
    map = map['game'];
    return GameDetails(
      gameName: map['gameName'] != null ? map['gameName'] as String : 'N/A',
      gameVersion:
          map['gameVersion'] != null ? map['gameVersion'] as String : 'N/A',
      achievements: map['availableGameStats']['achievements'] != null
          ? List<Achievement>.from(
              (map['availableGameStats']['achievements'] as List<dynamic>)
                  .map<Achievement?>(
                (x) => Achievement.fromMap(x as Map<String, dynamic>),
              ),
            )
          : const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameDetails.fromJson(String source) =>
      GameDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [gameName ?? "N/A", gameVersion ?? '', achievements ?? []];
}
