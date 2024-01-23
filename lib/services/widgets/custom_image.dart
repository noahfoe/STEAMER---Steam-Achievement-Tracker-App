import 'package:flutter/material.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double radius;
  final double height;
  final double width;
  const CustomNetworkImage({
    Key? key,
    required this.url,
    this.radius = 25,
    this.height = 50,
    this.width = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: KColors.transparent,
        foregroundImage: NetworkImage(
          url,
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
