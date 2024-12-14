import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../common/headphones_connection_ensuring_overlay.dart';
import 'auto_pause_section.dart';

class HeadphonesSettingsPage extends StatelessWidget {
  const HeadphonesSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(title: Text(l.pageHeadphonesSettingsTitle)),
      body: Center(
        child: HeadphonesConnectionEnsuringOverlay(
          builder: (_, h) {
            return ListView(
              children: [
                AutoPauseSection(headphones: h),
                const Divider(indent: 16, endIndent: 0),
                ListTile(
                  leading: const Icon(Icons.touch_app_outlined),
                  title: Text(l.pageHeadphonesSettingsGestures),
                  subtitle: Text(l.pageHeadphonesSettingsGesturesDesc),
                  onTap: () => Navigator.pushNamed(context, '/headphones_settings/gestures_settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.bluetooth_connected_outlined),
                  title: Text(l.connectionSettings),
                  subtitle: Text(l.connectionSettingsDesc),
                  onTap: () => Navigator.pushNamed(context, '/headphones_settings/connection_settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.noise_control_off_outlined),
                  title: Text(l.anc),
                  subtitle: Text(l.ancDesc),
                  onTap: () => Navigator.pushNamed(context, '/headphones_settings/anc_settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outlined),
                  title: Text(l.pageAboutTitle),
                  subtitle: Text(l.pageAboutMeHeader),
                  onTap: () => Navigator.pushNamed(context, '/settings/about'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
