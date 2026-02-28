import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
  });

  final String text;
  final String? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: <Widget>[
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SvgPicture.asset(icon!),
              ),
            Expanded(
                child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            )),
            const Icon(
              Icons.arrow_forward_ios, size: 13,
              // color: context.colorScheme.onBackground.withOpacity(0.85),
            ),
          ],
        ),
      ),
    );
  }
}
