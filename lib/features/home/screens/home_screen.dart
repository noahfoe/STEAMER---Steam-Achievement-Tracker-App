// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/features/home/controllers/home_screen_controller.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';
import 'package:steam_achievement_tracker/services/widgets/button.dart';
import 'package:steam_achievement_tracker/services/widgets/custom_image.dart';
import 'package:steam_achievement_tracker/services/widgets/my_app_bar.dart';

class HomeScreen extends StatelessWidget {
  final String steamID;

  const HomeScreen({
    Key? key,
    required this.steamID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.backgroundColor,
      appBar: myAppBar(
        title: 'STEAMER',
      ),
      drawer: const _Drawer(),
      body: GetBuilder<HomeScreenController>(
        init: HomeScreenController(steamID: steamID),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Visibility(
                    visible: controller.playerSummary.value !=
                        UserSteamInformation.empty(),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 100.0),
                          child: _Profile(),
                        ),
                        const SizedBox(height: 10),
                        const _StatsBody(),
                        const Text(
                          "Wallet Balance: ",
                          style: TextStyle(
                            color: KColors.activeTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Button(
                    onTap: () => controller.navigateToGamesScreen(context),
                    text: 'View Library',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsBody extends GetView<HomeScreenController> {
  const _StatsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DrawerTile extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const DrawerTile({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: const BoxDecoration(
          color: KColors.backgroundColor,
        ),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                color: KColors.activeTextColor,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              color: KColors.activeTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;

  const DrawerHeader({
    Key? key,
    required this.avatarUrl,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              CustomNetworkImage(
                url: avatarUrl,
                radius: 5,
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  color: KColors.activeTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Drawer extends GetView<HomeScreenController> {
  const _Drawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: KColors.primaryColor,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          DrawerHeader(
            avatarUrl: controller.playerSummary.value.avatar!,
            name: controller.playerSummary.value.steamName!,
          ),
          const SizedBox(height: 10),
          const DrawerTile(text: "Profile"),
          const DrawerTile(text: "Library"),
          const DrawerTile(text: "Achievements"),
          const DrawerTile(text: "Settings"),
        ],
      ),
    );
  }
}

class _Profile extends GetView<HomeScreenController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(
            top: 2.5,
            bottom: 2.5,
          ),
          child: CustomNetworkImage(
            url: controller.playerSummary.value.avatar!,
            radius: 5,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          controller.playerSummary.value.steamName!,
          style: const TextStyle(
            color: KColors.activeTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class EasyRichText extends StatelessWidget {
  final List<TextSpan> children;

  const EasyRichText({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: children,
      ),
    );
  }
}
