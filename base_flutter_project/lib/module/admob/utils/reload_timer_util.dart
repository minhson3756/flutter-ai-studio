import 'dart:async';
import 'dart:ui';

class ReloadTimerService {
  ReloadTimerService() {
    _watch = Stopwatch();
  }

  late Stopwatch _watch;
  Timer? _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;
  int _interval = 0;
  VoidCallback? _onReset;

  final StreamController<Duration> _streamController =
      StreamController.broadcast();

  Stream<Duration> get stream => _streamController.stream;

  bool get isRunning => _timer != null;

  void start({
    int? interval,
    VoidCallback? onReset,
  }) {
    if (_timer != null) {
      return;
    }
    _interval = interval ?? _interval;
    _onReset = onReset ?? _onReset;
    if (_interval <= 0) {
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _currentDuration = _watch.elapsed;
        _streamController.add(_currentDuration);
        if (_currentDuration.inSeconds >= _interval) {
          reset();
          _onReset?.call();
        }
      },
    );
    _watch.start();
  }

  void resume() {
    start();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    _currentDuration = _watch.elapsed;
    _streamController.add(_currentDuration);
  }

  void reset() {
    _watch.reset();
    _currentDuration = Duration.zero;
    _streamController.add(_currentDuration);
  }

  void dispose() {
    _timer?.cancel();
    _watch.stop();
  }
}
