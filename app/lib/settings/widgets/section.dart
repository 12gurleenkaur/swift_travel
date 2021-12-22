// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:swift_travel/utils/definitions.dart';

import 'constants.dart';
import 'cupertino_section.dart';

@immutable
abstract class AbstractSection extends StatelessWidget {
  final bool showBottomDivider;
  final Widget titleWidget;
  final EdgeInsetsGeometry titlePadding;

  const AbstractSection({
    Key? key,
    required this.titleWidget,
    this.titlePadding = defaultTitlePadding,
    this.showBottomDivider = false,
  }) : super(key: key);
}

class SettingsSection extends AbstractSection {
  final List<Widget> tiles;
  final TextStyle? titleTextStyle;
  final int? maxLines;
  final Widget? subtitle;
  final EdgeInsetsGeometry subtitlePadding;
  final TargetPlatform? platform;

  const SettingsSection({
    Key? key,
    required this.tiles,
    required Widget titleWidget,
    EdgeInsetsGeometry titlePadding = defaultTitlePadding,
    this.maxLines,
    this.subtitle,
    this.subtitlePadding = defaultTitlePadding,
    this.titleTextStyle,
    this.platform,
  })  : assert(maxLines == null || maxLines > 0, ""),
        super(
          key: key,
          titleWidget: titleWidget,
          titlePadding: titlePadding,
        );

  @override
  Widget build(BuildContext context) {
    switch (platform ?? Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return iosSection();

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return androidSection(context);

      default:
        return iosSection();
    }
  }

  @allowReturningWidgets
  Widget iosSection() {
    return CupertinoSettingsSection(
      tiles,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: titleTextStyle ?? const TextStyle(),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            child: titleWidget,
          ),
          if (subtitle != null)
            Padding(
              padding: subtitlePadding,
              child: subtitle,
            ),
        ],
      ),
      headerPadding: titlePadding,
    );
  }

  @allowReturningWidgets
  Widget androidSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: titlePadding,
        child: DefaultTextStyle(
          style: titleTextStyle ??
              TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          child: titleWidget,
        ),
      ),
      if (subtitle != null)
        Padding(
          padding: subtitlePadding,
          child: subtitle,
        ),
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tiles.length,
        separatorBuilder: (context, _) => const Divider(height: 1),
        itemBuilder: (context, i) => tiles[i],
      ),
      if (showBottomDivider) const Divider(height: 1)
    ]);
  }
}
