import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dual_connect_section.dart';
import 'ldac_section.dart';
import '../../common/headphones_connection_ensuring_overlay.dart';


class ConnectionSettingsPage extends StatelessWidget {
  const ConnectionSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(title: Text(l.connectionSettings)),
      body: Center(
        child: HeadphonesConnectionEnsuringOverlay(
          builder: (_, h) {
            return ListView(
              children: [
                DualConnectSection(headphones: h),
                const Divider(indent: 16, endIndent: 16),
                LdacSection(headphones: h),
              ],
            );
          },
        ),
      ),
    );
  }
}