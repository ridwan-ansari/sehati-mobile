import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssetUtils {
  static Widget svg(
    String path, {
    double? width,
    double? height,
    Color? color,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget image(
    String path, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
