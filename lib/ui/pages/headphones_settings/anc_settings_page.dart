import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'voice_mode_section.dart';
import '../../common/headphones_connection_ensuring_overlay.dart';
import 'anc_settings_section.dart';

class AncSettingsPage extends StatelessWidget {
  const AncSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(title: Text(l.anc)),
      body: Center(
        child: HeadphonesConnectionEnsuringOverlay(
          builder: (_, h) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      l.ancTypeWarning,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                VoiceModeSection(headphones: h),
                const Divider(indent: 16, endIndent: 16),
                AncSettingsSection(headphones: h),
              ],
            );
          },
        ),
      ),
    );
  }
}
