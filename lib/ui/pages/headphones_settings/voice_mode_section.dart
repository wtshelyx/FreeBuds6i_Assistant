import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../headphones/headphones_base.dart';
import '../../../headphones/headphones_data_objects.dart';
import '../../common/list_tile_switch.dart';

class VoiceModeSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const VoiceModeSection({Key? key, required this.headphones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return StreamBuilder<HeadphonesAncMode>(
      stream: headphones.ancMode.cast<HeadphonesAncMode>(),
      initialData: headphones.ancMode.valueOrNull ?? HeadphonesAncMode.off,
      builder: (context, ancModeSnapshot) {
        final ancMode = ancModeSnapshot.data ?? HeadphonesAncMode.off;
        final isAwarenessEnabled = ancMode == HeadphonesAncMode.awareness;
        return StreamBuilder<bool>(
          stream: headphones.voiceMode,
          initialData: headphones.voiceMode.valueOrNull ?? false,
          builder: (_, snapshot) {
            final isVoiceModeEnabled = snapshot.data ?? false;
            return ListTileSwitch(
              title: Text(l.voiceMode),
              subtitle: Text(l.voiceModeDesc),
              value: isVoiceModeEnabled,
              onChanged: isAwarenessEnabled
                  ? (newVal) => headphones.setVoiceMode(newVal)
                  : null,
            );
          },
        );
      },
    );
  }
}
