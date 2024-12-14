import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'triple_tap_section.dart';
import '../../common/headphones_connection_ensuring_overlay.dart';
import 'double_tap_section.dart';
import 'hold_section.dart';
import 'slide_section.dart';


class GesturesSettingsPage extends StatelessWidget {
  const GesturesSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(title: Text('Настройки жестов')),
      body: Center(
        child: HeadphonesConnectionEnsuringOverlay(
          builder: (_, h) {
            return ListView(
              children: [
                DoubleTapSection(headphones: h),
                const Divider(indent: 16, endIndent: 16),
                TripleTapSection(headphones: h),
                const Divider(indent: 16, endIndent: 16),
                HoldSection(headphones: h),
                const Divider(indent: 16, endIndent: 16),
                SlideSection(headphones: h),
                const SizedBox(height: 64),
              ],
            );
          },
        ),
      ),
    );
  }
}