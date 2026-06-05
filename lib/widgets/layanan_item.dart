import 'package:flutter/material.dart';

import 'asset_icon_image.dart';

class LayananItem extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  final double iconScale;

  const LayananItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.iconScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: AssetIconImage(
                asset: image,
                width: 50 * iconScale,
                height: 50 * iconScale,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
