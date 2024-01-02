
import 'package:flutter/material.dart';

class BackgrounImage extends StatelessWidget {
  const BackgrounImage({
    Key? key,
    required this.assetimage,
    required this.child,
  }) : super(key: key);
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