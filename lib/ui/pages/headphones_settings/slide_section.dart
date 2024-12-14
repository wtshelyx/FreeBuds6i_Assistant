import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../headphones/headphones_base.dart';
import '../../common/list_tile_switch.dart';

class SlideSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const SlideSection({Key? key, required this.headphones})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return StreamBuilder(
      stream: headphones.slide,
      initialData: headphones.slide.valueOrNull ?? false,
      builder: (_, snapshot) {
        return ListTileSwitch(
          title: Text(l.slide),
          subtitle: Text(l.slideDesc),
          value: snapshot.data!,
          onChanged: (newVal) => headphones.setSlide(newVal),
        );
      },
    );
  }
}
