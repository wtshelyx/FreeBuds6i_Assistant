import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_settings.dart';
import '../../common/headphones_connection_ensuring_overlay.dart';
import 'controls/headphones_controls_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_introCheck);
  }

  void _introCheck() async {
    final settings = context.read<AppSettings>();
    if (!(await settings.seenIntroduction.first)) {
      if (!context.mounted) return;
      final success =
          await Navigator.of(context).pushNamed('/introduction') as bool?;
      if (success ?? false) {
        await settings.setSeenIntroduction(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  // Получаем текущую тему из контекста
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: theme.colorScheme.background, // Navigation bar
          statusBarColor: Colors.transparent, // Status bar
        ),
      ),
      body: Center(
        child: HeadphonesConnectionEnsuringOverlay(
          builder: (_, h) => HeadphonesControlsWidget(headphones: h),
        ),
      ),
    );
  }
}
