import 'package:flutter/material.dart';

import '../../config/theme/palette.dart';

class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.onChanged,
    required this.groupValue,
    this.color,
  });

  final T value;
  final T groupValue;
  final void Function(T value) onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final customColor = color ?? Palette.primary;
    return Container(
      width: 22,
      height: 22,
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.5,
          color: customColor,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchOutCurve: Curves.ease,
        switchInCurve: Curves.ease,
        child: value == groupValue
            ? CircleAvatar(
                backgroundColor: customColor,
                radius: 6,
              )
            : const SizedBox(),
      ),
    );
  }
}
