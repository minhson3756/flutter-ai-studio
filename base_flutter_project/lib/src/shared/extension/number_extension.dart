import 'package:flutter/cupertino.dart';

extension NumberExtension on num {
  SizedBox get vSpace => SizedBox(
        height: toDouble(),
      );

  SizedBox get hSpace => SizedBox(
        width: toDouble(),
      );
}
