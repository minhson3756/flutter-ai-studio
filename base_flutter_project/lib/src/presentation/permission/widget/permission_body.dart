part of '../permission_screen.dart';

class PermissionBody extends StatefulWidget {
  const PermissionBody({super.key, this.adController});

  final NativeAdController? adController;

  @override
  State<PermissionBody> createState() => _PermissionContentState();
}

class _PermissionContentState extends State<PermissionBody>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Widget _buildItem({
    required String title,
    required ValueCubit<bool> cubit,
    required FutureOr<void> Function(bool value) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
          BlocBuilder<ValueCubit<bool>, bool>(
            bloc: cubit,
            builder: (context, state) => CustomSwitch(
              value: state,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox.square(
                  dimension: 150.r,
                  child: const Placeholder(),
                ),
                Padding(
                  padding: const EdgeInsets.all(25).r,
                  child: const Text(
                    'context.l10n.requirePermission',
                    textAlign: TextAlign.center,
                  ),
                ),
                if (Global.instance.androidSdkVersion <= 32 &&
                    Platform.isAndroid)
                  _buildItem(
                    title: 'Storage',
                    cubit: context.read<StoragePermissionCubit>(),
                    onChanged: (value) {
                      PermissionUtil.instance
                          .requestPermission(Permission.storage);
                    },
                  ),
                if (Global.instance.androidSdkVersion > 32 || Platform.isIOS)
                  _buildItem(
                    title: 'Photo & Video',
                    cubit: context.read<StoragePermissionCubit>(),
                    onChanged: (value) {
                      PermissionUtil.instance
                          .requestPermission(Permission.photos);
                    },
                  ),
                _buildItem(
                  title: 'Camera',
                  cubit: context.read<CameraPermissionCubit>(),
                  onChanged: (value) {
                    PermissionUtil.instance
                        .requestPermission(Permission.camera);
                  },
                ),
                _buildItem(
                  title: 'Notification',
                  cubit: context.read<NotificationPermissionCubit>(),
                  onChanged: (value) {
                    PermissionUtil.instance
                        .requestPermissionNotificationDefault(
                            openSetting: true);
                  },
                ),
              ],
            ),
          ),
        ),
        if (Global.instance.isFullAds)
          CommonNativeAd.control(
            controller: widget.adController,
            height: NativeAdSize.large,
            key: ValueKey(widget.adController?.controllerId),
          )
        else
          const SizedBox(),
        BlocBuilder<StoragePermissionCubit, bool>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: FilledButton(
                child: Text(state
                    ? context.l10n.continueText
                    : context.l10n.grantPermissionLater),
                onPressed: () {
                  context.replaceRoute(const HomeRoute());
                  SharedPreferencesManager.instance
                      .markFirstPermissionAsShown();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      PermissionUtil.instance.checkAllPermissions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
