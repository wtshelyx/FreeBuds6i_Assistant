import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../headphones/headphones_base.dart';
import '../../../headphones/headphones_data_objects.dart';
import '../../common/list_tile_radio.dart';

class AncSettingsSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const AncSettingsSection({Key? key, required this.headphones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return StreamBuilder<HeadphonesAncMode>(
      stream: headphones.ancMode.cast<HeadphonesAncMode>(),
      initialData: headphones.ancMode.valueOrNull ?? HeadphonesAncMode.off,
      builder: (context, ancModeSnapshot) {
        final ancMode = ancModeSnapshot.data ?? HeadphonesAncMode.off;
        final isNoiseCancellingEnabled = ancMode == HeadphonesAncMode.noiseCancel;
        return StreamBuilder<HeadphonesAncType>(
          stream: headphones.ancType,
          initialData:
          headphones.ancType.valueOrNull ?? HeadphonesAncType.general,
          builder: (context, ancTypeSnapshot) {
            final ancType = ancTypeSnapshot.data ?? HeadphonesAncType.general;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                   const EdgeInsets.fromLTRB(15, 8, 8, 8),
                   child: Text(
                    l.ancType,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                _AncTypeSelector(
                  value: ancType,
                  onChanged: isNoiseCancellingEnabled
                      ? (newType) => headphones.setAncType(newType)
                      : null,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _AncTypeSelector extends StatelessWidget {
  final HeadphonesAncType value;
  final ValueChanged<HeadphonesAncType>? onChanged;

  const _AncTypeSelector({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTileRadio(
          title: Text(l.ancDynamic),
          subtitle: Text(l.ancDynamicDesc),
          value: HeadphonesAncType.dynamic,
          groupValue: value,
          onChanged: onChanged,
        ),
        ListTileRadio(
          title: Text(l.ancCozy),
          subtitle: Text(l.ancCozyDesc),
          value: HeadphonesAncType.cozy,
          groupValue: value,
          onChanged: onChanged,
        ),
        ListTileRadio(
          title: Text(l.ancGeneral),
          subtitle: Text(l.ancGeneralDesc),
          value: HeadphonesAncType.general,
          groupValue: value,
          onChanged: onChanged,
        ),
        ListTileRadio(
          title: Text(l.ancUltra),
          subtitle: Text(l.ancUltraDesc),
          value: HeadphonesAncType.ultra,
          groupValue: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
