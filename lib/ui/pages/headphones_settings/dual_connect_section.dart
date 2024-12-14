import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../headphones/headphones_base.dart';
import '../../common/list_tile_switch.dart';

class DualConnectSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const DualConnectSection({Key? key, required this.headphones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return StreamBuilder(
      stream: headphones.dualConnect,
      initialData: headphones.dualConnect.valueOrNull ?? false,
      builder: (_, snapshot) {
        return ListTileSwitch(
          title: Text(l.dualConnect),
          subtitle: Text(l.dualConnectDesc),
          value: snapshot.data!,
          onChanged: (newVal) => headphones.setDualConnect(newVal),
        );
      },
    );
  }
}
