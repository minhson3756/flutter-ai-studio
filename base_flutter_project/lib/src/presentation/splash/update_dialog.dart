import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';

import '../../config/theme/palette.dart';
import '../../gen/assets.gen.dart';
import '../../shared/extension/context_extension.dart';

class UpdateDialog extends StatefulWidget {
  UpdateDialog({
    super.key,
    Upgrader? upgrader,
    this.margin,
    this.maxLines = 15,
    this.onIgnore,
    this.onLater,
    this.onUpdate,
    this.overflow = TextOverflow.ellipsis,
    this.showIgnore = true,
    this.showLater = true,
    this.showReleaseNotes = true,
  }) : upgrader = upgrader ?? Upgrader.sharedInstance;

  /// The upgraders used to configure the upgrade dialog.
  final Upgrader upgrader;

  /// The empty space that surrounds the card.
  ///
  /// The default margin is [Card.margin].
  final EdgeInsetsGeometry? margin;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// Called when the ignore button is tapped or otherwise activated.
  /// Return false when the default behavior should not execute.
  final BoolCallback? onIgnore;

  /// Called when the later button is tapped or otherwise activated.
  final VoidCallback? onLater;

  /// Called when the update button is tapped or otherwise activated.
  /// Return false when the default behavior should not execute.
  final BoolCallback? onUpdate;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// Hide or show Ignore button on dialog (default: true)
  final bool showIgnore;

  /// Hide or show Later button on dialog (default: true)
  final bool showLater;

  /// Hide or show release notes (default: true)
  final bool showReleaseNotes;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool displayed = false;

  @override
  void initState() {
    super.initState();
    widget.upgrader.initialize();
  }

  void forceRebuild() => setState(() {});

  void onUserUpdated() {
    // If this callback has been provided, call it.
    final doProcess = widget.onUpdate?.call() ?? true;

    if (doProcess) {
      widget.upgrader.sendUserToAppStore();
    }

    forceRebuild();
  }

  void onUserLater() {
    widget.onLater?.call();

    forceRebuild();
  }

  Center buildUpdateCard(BuildContext context) {
    final appMessages = widget.upgrader.determineMessages(context);
    final title = appMessages.message(UpgraderMessage.title);
    final message = widget.upgrader.body(appMessages);

    return Center(
      key: const Key('upgrader_alert_card'),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Assets.icons.update.svg(
                width: 69.r,
                height: 69.r,
                colorFilter: const ColorFilter.mode(
                  Palette.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xffADADAD),
              ),
            ),
            5.verticalSpace,
            Text(
              appMessages.message(UpgraderMessage.prompt) ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            16.verticalSpace,
            FilledButton(
              onPressed: () {
                widget.upgrader.saveLastAlerted();
                onUserUpdated();
              },
              child: Text(
                appMessages.message(UpgraderMessage.buttonTitleUpdate) ?? '',
              ),
            ),
            if (widget.showLater)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // Save the date/time as the last time alerted.
                      widget.upgrader.saveLastAlerted();

                      onUserLater();
                      forceRebuild();
                    },
                    child: SizedBox(
                      height: 30.h,
                      child: Text(
                        appMessages.message(UpgraderMessage.buttonTitleLater) ??
                            '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          initialData: widget.upgrader.state,
          stream: widget.upgrader.stateStream,
          builder:
              (BuildContext context, AsyncSnapshot<UpgraderState> snapshot) {
            final upgraderState = snapshot.data!;
            if (upgraderState.versionInfo != null) {
              if (widget.upgrader.shouldDisplayUpgrade()) {
                return buildUpdateCard(context);
              }
            }
            return const SizedBox.shrink();
          }),
    );
  }
}
