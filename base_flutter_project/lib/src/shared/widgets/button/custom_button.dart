import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.padding,
    required this.child,
    this.decoration,
    this.height,
    this.width,
    this.alignment,
  });

  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final Decoration? decoration;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        width: width,
        alignment: alignment ?? Alignment.center,
        decoration: decoration,
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
