// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserSteamInformation extends Equatable {
  /// The user's Steam ID.
  final String? steamID;

  /// The user's Steam name.
  final String? steamName;

  /// URL to the user's avatar.
  final String? avatar;

  /// The user's real name, if they have set it.
  final String? realName;

  const UserSteamInformation({
    required this.steamID,
    required this.steamName,
    this.avatar,
    this.realName,
  });

  UserSteamInformation copyWith({
    String? steamID,
    String? steamName,
    String? avatar,
    String? realName,
  }) {
    return UserSteamInformation(
      steamID: steamID ?? this.steamID,
      steamName: steamName ?? this.steamName,
      avatar: avatar ?? this.avatar,
      realName: realName ?? this.realName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'steamID': steamID,
      'steamName': steamName,
      'avatar': avatar,
      'realName': realName,
    };
  }

  factory UserSteamInformation.empty() {
    return const UserSteamInformation(
      steamID: null,
      steamName: null,
      avatar: null,
      realName: null,
    );
  }

  factory UserSteamInformation.fromSteamAPI(Map<String, dynamic> map) {
    return UserSteamInformation(
      steamID: map['steamid'] == null ? null : map['steamid'] as String,
      steamName:
          map['personaname'] == null ? null : map['personaname'] as String,
      avatar: map['avatarfull'].toString(),
      realName: map['realname'] == null ? null : map['realname'] as String,
    );
  }

  factory UserSteamInformation.fromMap(Map<String, dynamic> map) {
    return UserSteamInformation(
      steamID: map['steamID'] == null ? null : map['steamID'] as String,
      steamName: map['steamName'] == null ? null : map['steamName'] as String,
      avatar: map['avatar'] == null ? null : map['avatar'] as String,
      realName: map['realName'] != null ? map['realName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSteamInformation.fromJson(String source) =>
      UserSteamInformation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [steamID ?? '', steamName ?? '', avatar ?? '', realName ?? ''];
}
