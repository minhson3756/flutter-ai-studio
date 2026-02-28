part of '../uninstall_screen.dart';

class _ProblemPage extends StatefulWidget {
  const _ProblemPage();

  @override
  State<_ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<_ProblemPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.whatProblemsYouEncounterDuringUse,
            style: TextStyle(
              height: 1.1,
              fontSize: 24.sp,
              color: const Color(0xff171943),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 12).h,
            child: _buildItem(
              text: 'text',
              buttonLabel: 'text',
              onButtonTap: () {
                // TODO(all): Thêm sự kiện
                context.maybePop();
              },
            ),
          ),
          _buildItem(
            text: context.l10n.notCurrentlyAvailableForUse,
            buttonLabel: context.l10n.explore,
            onButtonTap: () {
              // TODO(all): Thêm sự kiện
              context.maybePop();
            },
          ),
          20.verticalSpace,
          if (Global.instance.isFullAds)
            CommonNativeAd(
              key: const Key('native_uninstall'),
              border: Border.all(color: Palette.adBorder),
              borderRadius: BorderRadius.circular(10),
              adConfig: adUnitsConfig.nativeUninstall,
            ),
        ],
      ),
    );
  }

  Widget _buildItem({
    AssetGenImage? image,
    required String text,
    required String buttonLabel,
    required VoidCallback onButtonTap,
  }) {
    return _ItemCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16).r,
      child: Row(
        children: [
          if (image != null)
            image.image(
              width: 36.r,
            )
          else
            36.r.hSpace,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4).w,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: FilledButton(
              onPressed: onButtonTap,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5).r,
              ),
              child: MarqueeText(
                text: buttonLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
