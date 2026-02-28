import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.padding,
    required this.child,
    this.decoration,
  });

  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: decoration,
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
