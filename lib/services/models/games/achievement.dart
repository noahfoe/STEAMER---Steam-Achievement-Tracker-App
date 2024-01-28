// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  /// API_NAME of achievement / Achievement Number
  final String name;

  /// The real name of achievement
  final String displayName;

  /// Defaults to 0 (unlocked)
  ///
  /// Updates to 1 if it has been unlocked
  final int achieved;

  /// The description of the achievement
  final String? description;

  /// URL to the achievement icon
  final String icon;

  /// URL to the locked achievement icon
  final String iconGray;

  /// Determines if the achievement is hidden or not
  final int hidden;

  const Achievement({
    required this.name,
    required this.displayName,
    required this.achieved,
    required this.description,
    required this.icon,
    required this.iconGray,
    required this.hidden,
  });

  Achievement copyWith({
    String? name,
    String? displayName,
    int? achieved,
    String? description,
    String? icon,
    String? iconGray,
    int? hidden,
  }) {
    return Achievement(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      achieved: achieved ?? this.achieved,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      iconGray: iconGray ?? this.iconGray,
      hidden: hidden ?? this.hidden,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'displayName': displayName,
      'defaultValue': achieved,
      'description': description,
      'icon': icon,
      'iconGray': iconGray,
      'hidden': hidden,
    };
  }

  factory Achievement.fromSharedPrefs(Map<String, dynamic> map) {
    return Achievement(
      name: map['name'] as String,
      displayName: map['displayName'] as String,
      achieved: map['defaultValue'] as int,
      description: map['description'] ?? 'No Description Given',
      icon: map['icon'] as String,
      iconGray: map['iconGray'] as String,
      hidden: map['hidden'] as int,
    );
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      name: map['name'] as String,
      displayName: map['displayName'] as String,
      achieved: map['defaultvalue'] as int,
      description: map['description'] != null
          ? map['description'] as String
          : "No Description Given",
      icon: map['icon'] as String,
      iconGray: map['icongray'] as String,
      hidden: map['hidden'] as int,
    );
  }

  factory Achievement.empty() {
    return const Achievement(
      name: '',
      displayName: '',
      achieved: 0,
      description: '',
      icon: '',
      iconGray: '',
      hidden: 0,
    );
  }

  static String formatAchievementName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  String toJson() => json.encode(toMap());

  factory Achievement.fromJson(String source) =>
      Achievement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      displayName,
      achieved,
      description ?? "No Description Given",
      icon,
      iconGray,
      hidden,
    ];
  }
}
