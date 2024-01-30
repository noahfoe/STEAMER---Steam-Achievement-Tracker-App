import 'package:flutter/material.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';
import 'package:steam_achievement_tracker/services/widgets/my_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Settings"),
      backgroundColor: KColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SettingsSection(
            title: const Text(
              "General",
              style: TextStyle(
                color: KColors.buttonColor,
              ),
            ),
            children: [
              _BasicSettingButton(
                title: "About",
                subtitle: "Version 1.0",
                icon: const Icon(
                  Icons.adb_outlined,
                  color: KColors.inactiveTextColor,
                ),
                onTap: () {},
              ),
              _BasicSettingButton(
                title: "Donate",
                subtitle: "Contributions are welcomed!",
                icon: const Icon(
                  Icons.attach_money_rounded,
                  color: KColors.inactiveTextColor,
                ),
                onTap: () {},
              ),
              _BasicSettingButton(
                title: "Support",
                subtitle: "For help and posting ideas.",
                icon: const Icon(
                  Icons.support_agent,
                  color: KColors.inactiveTextColor,
                ),
                onTap: () {},
              ),
            ],
          ),
          const _Divider(),
          _SettingsSection(
            title: const Text(
              "Account",
              style: TextStyle(
                color: KColors.buttonColor,
              ),
            ),
            children: [
              _BasicSettingButton(
                title: "Sign Out",
                subtitle: "Sign out of your account.",
                icon: const Icon(
                  Icons.logout,
                  color: KColors.inactiveTextColor,
                ),
                onTap: () {},
              ),
              _BasicSettingButton(
                title: "Refresh Game",
                subtitle:
                    "If you do not see your game in the app, try refreshing it here.",
                icon: const Icon(
                  Icons.refresh,
                  color: KColors.inactiveTextColor,
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: title,
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 5),
        Divider(
          thickness: 1,
          height: 1,
          indent: 25,
          endIndent: 25,
          color: KColors.inactiveTextColor,
        ),
      ],
    );
  }
}

class _BasicSettingButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon icon;
  final Function()? onTap;
  const _BasicSettingButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        color: KColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: KColors.activeTextColor,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: KColors.inactiveTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
