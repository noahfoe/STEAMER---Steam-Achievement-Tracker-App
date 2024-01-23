import 'package:flutter/material.dart';
import 'package:steam_achievement_tracker/services/models/games/achievement.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';

class GameDetailsListTile extends StatelessWidget {
  final Achievement achievement;

  const GameDetailsListTile({
    Key? key,
    required this.achievement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: KColors.backgroundColor,
      leading: achievement.achieved == 1
          ? Image.network(achievement.icon)
          : Image.network(achievement.iconGray),
      title: Text(
        achievement.displayName,
        style: const TextStyle(
          color: KColors.activeTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        achievement.description ?? "No Description",
        style: const TextStyle(
          color: KColors.inactiveTextColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      dense: true,
    );
  }
}
