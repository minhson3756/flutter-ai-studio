import 'package:flutter/cupertino.dart';

import '../../gen/assets.gen.dart';

class CustomFadeInImage extends StatelessWidget {
  const CustomFadeInImage({
    super.key,
    required this.image,
    this.fit,
    this.alignment = Alignment.center,
    this.width,
    this.height,
  });

  final ImageProvider<Object> image;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: Assets.images.placeholderImage.provider(),
      image: image,
      alignment: alignment,
      fit: fit,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }
}
