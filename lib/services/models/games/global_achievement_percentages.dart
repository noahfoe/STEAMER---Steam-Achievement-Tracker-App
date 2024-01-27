// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:convert';

import 'package:equatable/equatable.dart';

class GlobalAchievementPercentages extends Equatable {
  /// The API_NAME of the achievement.
  final String name;

  /// The percentage of players that have unlocked the achievement.
  final double percent;
  const GlobalAchievementPercentages({
    required this.name,
    required this.percent,
  });

  GlobalAchievementPercentages copyWith({
    String? name,
    double? percent,
  }) {
    return GlobalAchievementPercentages(
      name: name ?? this.name,
      percent: percent ?? this.percent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'percent': percent,
    };
  }

  factory GlobalAchievementPercentages.fromMap(Map<String, dynamic> map) {
    return GlobalAchievementPercentages(
      name: map['name'] as String,
      percent: map['percent'].toDouble() as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalAchievementPercentages.fromJson(String source) =>
      GlobalAchievementPercentages.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, percent];
}
