import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../headphones/headphones_base.dart';
import '../../common/list_tile_switch.dart';

class LdacSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const LdacSection({Key? key, required this.headphones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return StreamBuilder(
      stream: headphones.ldacState,
      initialData: headphones.ldacState.valueOrNull ?? false,
      builder: (_, snapshot) {
        return ListTileSwitch(
          title: Text(l.ldac),
          subtitle: Text(l.ldacDesc),
          value: snapshot.data!,
          onChanged: (newVal) => headphones.setLdacState(newVal),
        );
      },
    );
  }
}
