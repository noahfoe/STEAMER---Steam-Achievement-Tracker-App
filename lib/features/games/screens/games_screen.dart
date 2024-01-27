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
    return GetBuilder<GamesScreenController>(
      init: GamesScreenController(steamID: steamID),
      builder: (GamesScreenController controller) {
        return Scaffold(
          backgroundColor: KColors.backgroundColor,
          appBar: myAppBar(
            title: 'Library',
          ),
          body: controller.obx(
            onLoading: const Center(child: CircularProgressIndicator()),
            (state) => Obx(
              () => ListView.builder(
                itemCount: controller.filteredGamesList.value.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Search Bar
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: controller.searchGamesList,
                            style: const TextStyle(
                              color: KColors.activeTextColor,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: KColors.activeTextColor,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: KColors.activeTextColor,
                              ),
                              filled: true,
                              fillColor: KColors.backgroundColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        GameListTile(
                          game: controller.filteredGamesList.value[index],
                          steamId: steamID,
                        )
                      ],
                    );
                  }
                  return GameListTile(
                    game: controller.filteredGamesList.value[index],
                    steamId: steamID,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
