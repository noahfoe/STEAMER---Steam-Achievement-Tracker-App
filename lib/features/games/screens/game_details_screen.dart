// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/features/games/controllers/game_details_controller.dart';
import 'package:steam_achievement_tracker/features/games/widgets/expandable_game_tile.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';
import 'package:steam_achievement_tracker/services/widgets/my_app_bar.dart';

class GameDetailsScreen extends StatelessWidget {
  final int appId;
  final String gameName;
  final String steamID;

  const GameDetailsScreen({
    Key? key,
    required this.appId,
    required this.steamID,
    required this.gameName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameDetailsScreenController>(
      init: GameDetailsScreenController(
        appID: appId,
        steamID: steamID,
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: KColors.backgroundColor,
          appBar: myAppBar(title: gameName),
          body: controller.obx(
            onLoading: const Center(child: CircularProgressIndicator()),
            (state) => ListView(
              children: [
                if (controller
                    .gameInfoAndAchievements.value.allAchievements!.isNotEmpty)
                  Column(
                    children: [
                      // All Achievements
                      Obx(
                        () => Visibility(
                          visible: controller.gameInfoAndAchievements.value
                              .allAchievements!.isNotEmpty,
                          child: Obx(
                            () => ExpandableGameTile(
                              isTotal: true,
                              gameName: gameName,
                              achievements: controller.gameInfoAndAchievements
                                      .value.allAchievements ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                      // Unlocked Achievements
                      Obx(
                        () => Visibility(
                          visible: controller.gameInfoAndAchievements.value
                              .unlockedAchievements!.isNotEmpty,
                          child: Obx(
                            () => ExpandableGameTile(
                              gameName: "Unlocked Achievements",
                              achievements: controller.gameInfoAndAchievements
                                      .value.unlockedAchievements ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                      // Locked Achievements
                      Obx(
                        () => Visibility(
                          visible: controller.gameInfoAndAchievements.value
                              .lockedAchievements!.isNotEmpty,
                          child: Obx(
                            () => ExpandableGameTile(
                              gameName: "Locked Achievements",
                              achievements: controller.gameInfoAndAchievements
                                      .value.lockedAchievements ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  // No Achievements State
                  const Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          "This game does not have any Steam achievements",
                          style: TextStyle(
                            color: KColors.activeTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
