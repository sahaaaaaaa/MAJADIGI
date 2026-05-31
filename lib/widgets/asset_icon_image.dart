import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetIconImage extends StatelessWidget {
  const AssetIconImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (asset.startsWith('http://') || asset.startsWith('https://')) {
      return Image.network(
        asset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.apps, size: width ?? height ?? 28);
        },
      );
    }

    if (asset.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(asset, width: width, height: height, fit: fit);
    }

    return Image.asset(asset, width: width, height: height, fit: fit);
  }
}
