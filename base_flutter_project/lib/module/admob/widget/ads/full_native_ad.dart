import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ads/ads_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../src/shared/cubit/value_cubit.dart';
import '../../../../src/shared/global.dart';
import '../../../../src/shared/helpers/logger_utils.dart';
import '../../../../src/shared/helpers/my_completer.dart';
import '../../../../src/shared/helpers/utils.dart';
import '../../model/ad_config/ad_config.dart';
import '../../utils/enum/ad_factory.dart';
import '../../utils/native_full_util.dart';
import '../../utils/utils.dart';

final nativeFullUtil = NativeFullUtil(
  adConfig: adUnitsConfig.nativeFull,
  factoryId: AdFactory.fullNativeAd.name,
);

OverlayEntry? _overlayEntry;

Future<void> showFullNativeAd({
  VoidCallback? onClose,
  required NativeFullUtil nativeAdUtil,
}) async {
  if (!Global.instance.isFullAds) {
    onClose?.call();
    return;
  }
  if (!nativeAdUtil.adConfig.isEnable) {
    onClose?.call();
    return;
  }
  final MyCompleter<void> completer = MyCompleter();
  _removeOverlay();
  _overlayEntry = OverlayEntry(
    builder: (context) {
      return FullNativeAd(
        nativeAdUtil: nativeAdUtil,
        onClose: () {
          onClose?.call();
          completer.complete();
        },
      );
    },
  );
  try {
    Overlay.of(appContext).insert(_overlayEntry!);
  } on Exception catch (e) {
    logger.e(e);
    onClose?.call();
    completer.complete();
  }
  return completer.future;
}

void _removeOverlay() {
  try {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  } on Exception catch (e) {
    logger.e(e);
  }
}

class FullNativeAd extends StatefulWidget {
  const FullNativeAd({
    super.key,
    required this.onClose,
    required this.nativeAdUtil,
  });

  final VoidCallback onClose;
  final NativeFullUtil nativeAdUtil;

  @override
  State<FullNativeAd> createState() => _FullNativeAdState();
}

class _FullNativeAdState extends State<FullNativeAd> {
  NativeAdController? controller;
  final ValueCubit<int> _countDownCubit = ValueCubit<int>(1);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = widget.nativeAdUtil.getController();
    if (controller == null || controller!.status.isLoadFailed) {
      closeAd();
      return;
    }
    controller
      ?..onAdFailedToLoad = (_, __) {
        closeAd();
      }
      ..onAdImpression = (_) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_countDownCubit.state > 0) {
            _countDownCubit.update(_countDownCubit.state - 1);
          } else {
            timer.cancel();
          }
        });
      };
  }

  void closeAd() {
    _removeOverlay();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: MyNativeAd2(
        height: 1.sh,
        controller: controller,
        hasCloseButton: true,
        customCloseButton: _buildCloseButton(controller!.factoryId),
        loadingWidget: FullScreenAdLoading.instance.lottieLoading(),
      ),
    );
  }

  Positioned? _buildCloseButton(String factoryId) {
    return Positioned(
      top: MediaQuery.of(context).padding.top.clamp(40, 70),
      right: 8,
      child: BlocBuilder<ValueCubit<int>, int>(
        bloc: _countDownCubit,
        builder: (context, state) {
          return _CloseButton(
            count: state,
            onTap: () {
              closeAd();
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      widget.nativeAdUtil.disposeController(controller!);
    }
    timer?.cancel();
    _countDownCubit.close();
    super.dispose();
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap, required this.count});

  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff737373),
            ),
          ),
        ),
        if (count > 0)
          Positioned.fill(
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: const Icon(Icons.close, color: Colors.white, size: 15),
              ),
            ),
          ),
      ],
    );
  }
}
