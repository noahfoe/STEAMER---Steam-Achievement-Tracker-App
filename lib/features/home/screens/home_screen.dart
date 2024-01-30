// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steam_achievement_tracker/features/home/controllers/home_screen_controller.dart';
import 'package:steam_achievement_tracker/features/settings/screens/settings_screen.dart';
import 'package:steam_achievement_tracker/services/models/user/user_steam_information.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';
import 'package:steam_achievement_tracker/services/utils/extensions/int_extensions.dart';
import 'package:steam_achievement_tracker/services/utils/extensions/string_extensions.dart';
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
          return Column(
            children: [
              Expanded(
                child: Padding(
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            Obx(
                              () => HomeScreenContainer(
                                title: "Total Achievements",
                                subtitle: controller.gameDetails.value
                                    .map((e) => e.allAchievements)
                                    .expand((element) => element!)
                                    .length
                                    .toString()
                                    .toNumberFormat(),
                              ),
                            ),
                            Obx(
                              () => HomeScreenContainer(
                                title: "Unlocked Achievements",
                                subtitle: controller.gameDetails.value
                                    .map((e) => e.unlockedAchievements)
                                    .expand((element) => element!)
                                    .length
                                    .toString()
                                    .toNumberFormat(),
                              ),
                            ),
                            Obx(
                              () => HomeScreenContainer(
                                title: "Locked Achievements",
                                subtitle: controller.gameDetails.value
                                    .map((e) => e.lockedAchievements)
                                    .expand((element) => element!)
                                    .length
                                    .toString()
                                    .toNumberFormat(),
                              ),
                            ),
                            Obx(
                              () => HomeScreenContainer(
                                title: "Total Games",
                                subtitle: controller.gameDetails.value.length
                                    .toString()
                                    .toNumberFormat(),
                              ),
                            ),
                            Obx(
                              () => HomeScreenContainer(
                                title: "Total Hours Played",
                                subtitle:
                                    controller.playerGamesList.value.isNotEmpty
                                        ? controller.playerGamesList.value
                                            .map((e) => e.playtimeForever)
                                            .reduce((value, element) =>
                                                value! + element!)!
                                            .minutesToHours()
                                            .toString()
                                            .toNumberFormat()
                                        : "0",
                              ),
                            ),
                            Obx(
                              () => HomeScreenContainer(
                                title: "100%ed Games",
                                subtitle: controller.gameDetails.value
                                    .where(
                                      (element) => element
                                              .allAchievements!.isEmpty
                                          ? false
                                          : element.lockedAchievements!.isEmpty,
                                    )
                                    .length
                                    .toString()
                                    .toNumberFormat(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Center(
                        child: Button(
                          onTap: () =>
                              controller.navigateToGamesScreen(context),
                          text: 'View Library',
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
                color: KColors.darkBackgroundColor.withOpacity(0.5),
                child: Center(
                  child: Text(
                    "Steam ID: ${controller.steamID}",
                    style: const TextStyle(
                      color: KColors.inactiveTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HomeScreenContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function()? onTap;

  const HomeScreenContainer({
    Key? key,
    required this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 125,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: KColors.lightBackgroundColor,
              blurRadius: 2,
              offset: Offset(0, 1.5),
              spreadRadius: 1,
            ),
          ],
          color: KColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: KColors.activeTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Visibility(
              visible: subtitle != null,
              child: Text(
                subtitle ?? "",
                style: const TextStyle(
                  color: KColors.menuHighlightColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
  final Icon icon;
  final Function()? onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: const BoxDecoration(
          color: KColors.backgroundColor,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: KColors.activeTextColor,
              ),
            ),
            /* const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              color: KColors.activeTextColor,
            ), */
          ],
        ),
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int steamLevel;

  const DrawerHeader({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.steamLevel,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: KColors.activeTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Steam Level: $steamLevel",
                    style: const TextStyle(
                      color: KColors.inactiveTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
          Obx(
            () => DrawerHeader(
              avatarUrl: controller.playerSummary.value.avatar!,
              steamLevel: controller.steamLevel.value,
              name: controller.playerSummary.value.steamName!,
            ),
          ),
          const SizedBox(height: 10),
          const DrawerTile(
            text: "Profile",
            icon: Icon(
              Icons.person_outline,
              color: KColors.inactiveTextColor,
            ),
          ),
          const DrawerTile(
            text: "Library",
            icon: Icon(
              Icons.library_books_outlined,
              color: KColors.inactiveTextColor,
            ),
          ),
          const DrawerTile(
            text: "Achievements",
            icon: Icon(
              Icons.checklist_outlined,
              color: KColors.inactiveTextColor,
            ),
          ),
          const Divider(),
          DrawerTile(
            text: "Settings",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: KColors.inactiveTextColor,
            ),
          ),
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
          child: Obx(
            () => CustomNetworkImage(
              url: controller.playerSummary.value.avatar!,
              radius: 5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                controller.playerSummary.value.steamName!,
                style: const TextStyle(
                  color: KColors.activeTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Obx(
              () => Text(
                "Steam Level: ${controller.steamLevel.value}",
                style: const TextStyle(
                  color: KColors.inactiveTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
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
