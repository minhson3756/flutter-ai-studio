part of '../uninstall_screen.dart';

class _ItemCard extends Container {
  _ItemCard({
    super.child,
    super.padding,
    super.margin,
  });

  @override
  Decoration? get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Palette.primary.withOpacity(0.3),
          width: 1.r,
        ),
      );
}
