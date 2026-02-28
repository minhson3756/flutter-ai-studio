import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../extension/context_extension.dart';
import 'utils.dart';

class ShortcutUtils {
  ShortcutUtils._();

  static final ShortcutUtils instance = ShortcutUtils._();
  String? shortcutType;
  bool isSplash = true;
  late final quickActions = const QuickActions();

  Future<bool> initialize() async {
    final completer = Completer<bool>();
    // khởi tạo và lắng nghe sự kiện bấm vào shortcut
    quickActions.initialize((String shortcutType) {
      this.shortcutType = shortcutType;
      if (!completer.isCompleted) {
        // trả về true khi user vào app bằng cách bấm vào shortcut
        completer.complete(true);
      }
      // trường hợp app đang được ẩn xuống background
      // user bấm vào shortcut
      if (!isSplash) {
        handleShortcut();
      }
    });

    setShortcutItems();

    Future.delayed(const Duration(seconds: 1), () {
      // user vào app mà không thông qua shortcut
      // trả về false
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  /// Thêm short cut item
  void setShortcutItems() {
    quickActions.setShortcutItems(<ShortcutItem>[
      // TODO(all): item home test, xóa item này
      const ShortcutItem(
        type: 'home',
        localizedTitle: 'Home',
        icon: 'home',
      ),
      ShortcutItem(
        type: 'uninstall',
        localizedTitle: appContext.l10n.uninstall,
        icon: 'remove',
      ),
    ]);
  }

  ///Thực hiện các hành động dựa trên shortcut
  void handleShortcut() {
    final PageRouteInfo? route = switch (shortcutType) {
      'home' => const HomeRoute(),
      'uninstall' => const UninstallRoute(),
      _ => null
    };
    if (route == null) {
      return;
    }
    getIt<AppRouter>().replace(route);
  }
}
