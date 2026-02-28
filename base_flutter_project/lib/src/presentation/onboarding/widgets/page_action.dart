part of '../onboarding_screen.dart';

class PageAction extends StatefulWidget {
  const PageAction({
    super.key,
    required this.activeIndex,
    required this.pageController,
    required this.onNextTap,
  });

  final int activeIndex;
  final PageController pageController;
  final VoidCallback onNextTap;

  @override
  State<PageAction> createState() => _PageActionState();
}

class _PageActionState extends State<PageAction> {
  @override
  Widget build(BuildContext context) {
    final text = switch (widget.activeIndex) {
      0 => context.l10n.next,
      1 => context.l10n.next,
      2 => context.l10n.next,
      _ => context.l10n.start,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: widget.onNextTap,
            child: Text(
              text,
            ),
          ),
          16.verticalSpace,
          CustomIndicator(
            length: context.read<OnboardingController>().totalPage,
            currentIndex: widget.activeIndex,
          ),
        ],
      ),
    );
  }
}
