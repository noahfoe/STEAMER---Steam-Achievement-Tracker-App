import 'package:flutter/material.dart';
import 'package:steam_achievement_tracker/features/games/widgets/game_details_list_tile.dart';
import 'package:steam_achievement_tracker/services/models/games/achievement.dart';
import 'package:steam_achievement_tracker/services/models/games/global_achievement_percentages.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';

class ExpandableGameTile extends StatelessWidget {
  final String gameName;
  final bool isTotal;
  final List<Achievement> achievements;
  final List<GlobalAchievementPercentages> globalAchievementPercentages;

  const ExpandableGameTile({
    Key? key,
    this.isTotal = false,
    required this.gameName,
    required this.achievements,
    required this.globalAchievementPercentages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        gameName,
        style: const TextStyle(
          color: KColors.activeTextColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      // Calculate Percentage of total achievement progress
      // Sum all achieved achievements / sum of all achievements
      // Turn it into a percentage
      subtitle: isTotal
          ? Text(
              "${((achievements.where((element) => element.achieved == 1).length / achievements.length) * 100).toDouble().round()}% Total Achievements Unlocked",
              style: const TextStyle(
                color: KColors.inactiveTextColor,
                fontWeight: FontWeight.w400,
              ),
            )
          : achievements[0].achieved == 1
              ? Text(
                  "${achievements.length} Unlocked Achievements",
                  style: const TextStyle(
                    color: KColors.inactiveTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Text(
                  "${achievements.length} Locked Achievements",
                  style: const TextStyle(
                    color: KColors.inactiveTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          itemBuilder: (context, index) => GameDetailsListTile(
            achievement: achievements[index],
            globalAchievementPercentages: globalAchievementPercentages,
          ),
        ),
      ],
    );
  }
}
