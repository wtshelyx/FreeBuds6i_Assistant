import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../headphones/headphones_base.dart';
import '../../../headphones/headphones_data_objects.dart';
import '../../common/list_tile_radio.dart';
import '../../common/list_tile_switch.dart';
import '../disabled.dart';

class TripleTapSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const TripleTapSection({Key? key, required this.headphones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final tt = t.textTheme;
    final l = AppLocalizations.of(context)!;
    return StreamBuilder<HeadphonesGestureSettings>(
      stream: headphones.gestureSettings,
      initialData: headphones.gestureSettings.valueOrNull ??
          const HeadphonesGestureSettings(),
      builder: (context, snapshot) {
        final gs = snapshot.data!;
        final enabled =
        (gs.tripleTapLeft != HeadphonesGestureTripleTap.nothing ||
            gs.tripleTapRight != HeadphonesGestureTripleTap.nothing);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTileSwitch(
              title: Text(l.pageHeadphonesSettingsTripleTap),
              subtitle: Text(l.pageHeadphonesSettingsTripleTapDesc),
              value: enabled,
              onChanged: (newVal) {
                final g = newVal
                    ? HeadphonesGestureTripleTap.previous
                    : HeadphonesGestureTripleTap.nothing;
                headphones.setGestureSettings(
                  HeadphonesGestureSettings(
                    tripleTapLeft: g,
                    tripleTapRight: g,
                  ),
                );
              },
            ),
            Disabled(
              disabled: !enabled,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: _TripleTapSetting(
                        title: Text(
                          l.pageHeadphonesSettingsLeftBud,
                          style: tt.titleMedium,
                        ),
                        value: gs.tripleTapLeft,
                        onChanged: enabled
                            ? (g) => headphones.setGestureSettings(
                          HeadphonesGestureSettings(tripleTapLeft: g),
                        )
                            : null,
                      ),
                    ),
                    Expanded(
                      child: _TripleTapSetting(
                        title: Text(
                          l.pageHeadphonesSettingsRightBud,
                          style: tt.titleMedium,
                        ),
                        value: gs.tripleTapRight,
                        onChanged: enabled
                            ? (g) => headphones.setGestureSettings(
                          HeadphonesGestureSettings(tripleTapRight: g),
                        )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TripleTapSetting extends StatelessWidget {
  final Widget? title;
  final HeadphonesGestureTripleTap? value;
  final void Function(HeadphonesGestureTripleTap?)? onChanged;

  const _TripleTapSetting({
    Key? key,
    required this.value,
    this.onChanged,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 6),
              child: title!,
            ),
            const Divider(indent: 32, endIndent: 32),
          ],
          ListTileRadio(
            title: Text(l.pageHeadphonesSettingsTripleTapNextSong),
            value: HeadphonesGestureTripleTap.next,
            dense: true,
            groupValue: value,
            onChanged: onChanged,
          ),
          ListTileRadio(
            title: Text(l.pageHeadphonesSettingsTripleTapPrevSong),
            value: HeadphonesGestureTripleTap.previous,
            dense: true,
            groupValue: value,
            onChanged: onChanged,
          ),
          ListTileRadio(
            title: Text(l.pageHeadphonesSettingsTripleTapNone),
            value: HeadphonesGestureTripleTap.nothing,
            dense: true,
            groupValue: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
