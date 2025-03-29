import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetSVGImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? radiusAll;
  final double radiusTopRight;
  final double radiusTopLeft;
  final double radiusBottomRight;
  final double radiusBottomLeft;
  final double? imageHeight;
  final double? imageWidth;
  final BoxFit imageFitType;
  final color;

  const AssetSVGImageWidget(this.imageUrl,
      {Key? key,
        this.radiusAll,
        this.radiusTopLeft = 0.0,
        this.radiusBottomRight = 0.0,
        this.radiusBottomLeft = 0.0,
        this.radiusTopRight = 0.0,
        this.imageHeight,
        this.imageWidth,
        this.color,
        this.imageFitType = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radiusAll == null
          ? BorderRadius.only(
          topRight: Radius.circular(radiusTopRight),
          topLeft: Radius.circular(radiusTopLeft),
          bottomLeft: Radius.circular(radiusBottomLeft),
          bottomRight: Radius.circular(radiusBottomRight))
          : BorderRadius.circular(radiusAll!),
      child: SvgPicture.asset(
          imageUrl,
          color: color
      ),
    );
  }
}
