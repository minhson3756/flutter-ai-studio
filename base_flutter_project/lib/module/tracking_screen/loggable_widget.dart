import 'package:flutter/material.dart';

import 'screen_logger.dart';

/// Nếu muốn tracking screen trên Firebase Analytic,
/// thay thế StatefulWidget bằng StatefulLoggableWidget
/// và StatelessWidget bằng StatelessLoggableWidget
abstract class StatefulLoggableWidget extends StatefulWidget {
  const StatefulLoggableWidget({super.key});

  @override
  StatefulElement createElement() {
    AnalyticLogger.instance.logScreen(runtimeType.toString());
    return _StatefulTrackerElement(this);
  }
}

class _StatefulTrackerElement extends StatefulElement {
  _StatefulTrackerElement(StatefulLoggableWidget super.widget);
}

abstract class StatelessLoggableWidget extends StatelessWidget {
  const StatelessLoggableWidget({super.key});

  @override
  StatelessElement createElement() {
    AnalyticLogger.instance.logScreen(runtimeType.toString());
    return _StatelessTrackerElement(this);
  }
}

class _StatelessTrackerElement extends StatelessElement {
  _StatelessTrackerElement(StatelessLoggableWidget super.hooks);
}
