
import 'package:flutter/material.dart';

class BackgrounImage extends StatelessWidget {
  const BackgrounImage({
    super.key,
    required this.assetimage,
    required this.child,
  });
  final AssetImage assetimage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: assetimage,
            fit: BoxFit.cover,
          ),
        ),
        child: child);
  }
}