part of '../uninstall_screen.dart';

class _UninstallPage extends StatefulWidget {
  const _UninstallPage();

  @override
  State<_UninstallPage> createState() => _UninstallPageState();
}

class _UninstallPageState extends State<_UninstallPage> {
  final seasonCubit = ValueCubit<int>(0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.whyUninstallApp(AppConstants.appName),
            style: TextStyle(
              height: 1.1,
              fontSize: 24.sp,
              color: const Color(0xff171943),
            ),
          ),
          14.verticalSpace,
          BlocBuilder<ValueCubit<int>, int>(
            bloc: seasonCubit,
            builder: (context, state) {
              return Column(
                children: [
                  _buildItem(text: context.l10n.difficultToUse, value: 0),
                  _buildItem(text: context.l10n.tooManyAds, value: 1),
                  _buildItem(text: context.l10n.others, value: 2),
                ],
              );
            },
          ),
          BlocSelector<ValueCubit<int>, int, bool>(
            bloc: seasonCubit,
            selector: (state) {
              return state == 2;
            },
            builder: (context, isOthers) {
              if (!isOthers) {
                return const SizedBox();
              }
              return _ItemCard(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16).r,
                margin: const EdgeInsets.symmetric(vertical: 6).h,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xffb0b0b0),
                    ),
                    hintText: context.l10n.pleaseEnterReasonForUninstallingApp(
                        AppConstants.appName),
                  ),
                  minLines: 4,
                  maxLines: 4,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String text,
    required int value,
  }) {
    return GestureDetector(
      onTap: () {
        seasonCubit.update(value);
      },
      behavior: HitTestBehavior.opaque,
      child: _ItemCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16).r,
        margin: const EdgeInsets.symmetric(vertical: 6).h,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            8.horizontalSpace,
            CustomRadio(
              groupValue: seasonCubit.state,
              value: value,
              onChanged: (value) {
                seasonCubit.update(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
