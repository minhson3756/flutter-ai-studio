import 'dart:async';
import 'dart:isolate';

typedef EntryPointType = FutureOr<void> Function(
    SendPort sendPort, dynamic message);

class IsolateController {
  IsolateController._(this.close, this.send);

  final void Function() close;
  final void Function(dynamic message) send;

  static Future<IsolateController> spawn({
    required FutureOr<void> Function(dynamic message) callback,
    required EntryPointType entryPoint,
    bool closeWhenComplete = false,
  }) async {
    final completer = Completer<IsolateController>();
    final ReceivePort receivePort = ReceivePort();
    SendPort? isolateSendPort;
    final _IsolateArg arg = _IsolateArg(
      sendPort: receivePort.sendPort,
      entryPoint: entryPoint,
    );
    final Isolate isolate = await Isolate.spawn(
      _entryPoint,
      arg,
    );

    void send(dynamic message) {
      isolateSendPort?.send(message);
    }

    void close() {
      receivePort.close();
      isolate.kill();
    }

    receivePort.listen((message) async {
      if (message is SendPort) {
        isolateSendPort = message;
        completer.complete(IsolateController._(close, send));
      } else {
        if (isolateSendPort != null) {
          await callback(message);
          if (closeWhenComplete) {
            close();
          }
        }
      }
    });

    return completer.future;
  }

  static FutureOr<void> _entryPoint(_IsolateArg arg) async {
    final ReceivePort isolateReceivePort = ReceivePort();
    arg.sendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((message) async {
      await arg.entryPoint(arg.sendPort, message);
    });
  }
}

class _IsolateArg {
  _IsolateArg({required this.sendPort, required this.entryPoint});

  final SendPort sendPort;
  final EntryPointType entryPoint;
}
