// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/features/games/controllers/games_screen_controller.dart';
import 'package:steam_achievement_tracker/features/games/widgets/game_list_tile.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';
import 'package:steam_achievement_tracker/services/widgets/my_app_bar.dart';

class GamesScreen extends StatelessWidget {
  final String steamID;

  const GamesScreen({
    Key? key,
    required this.steamID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.backgroundColor,
      appBar: myAppBar(
        title: 'Library',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: GetBuilder<GamesScreenController>(
        init: GamesScreenController(steamID: steamID),
        builder: (controller) {
          return controller.obx(
            onLoading: const Center(child: CircularProgressIndicator()),
            (state) => Obx(
              () => ListView.builder(
                itemCount: controller.playerGamesList.value.length,
                itemBuilder: (context, index) {
                  return GameListTile(
                    game: controller.playerGamesList.value[index],
                    steamId: steamID,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
