import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'eq_settings_section.dart';
import '../../common/headphones_connection_ensuring_overlay.dart';


class EqSettingsPage extends StatelessWidget {
  const EqSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(title: Text(l.eq)),
      body: Center(
        child: HeadphonesConnectionEnsuringOverlay(
          builder: (_, h) {
            return ListView(
              children: [
                EqSettingsSection(headphones: h),
              ],
            );
          },
        ),
      ),
    );
  }
}