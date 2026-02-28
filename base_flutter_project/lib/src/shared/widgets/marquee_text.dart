import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatelessWidget {
  const MarqueeText({
    super.key,
    required this.text,
    this.style,
    this.blankSpace = 10,
  });

  final String text;
  final TextStyle? style;
  final double blankSpace;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        painter.layout();
        final overflow = painter.size.width > constraints.maxWidth - 10.w;
        if (overflow) {
          return SizedBox(
            height: (style?.fontSize ?? 14.sp) + 2,
            child: Marquee(
              text: text,
              style: style,
              blankSpace: blankSpace,
            ),
          );
        }
        return Text(
          text,
          style: style,
        );
      },
    );
  }
}
