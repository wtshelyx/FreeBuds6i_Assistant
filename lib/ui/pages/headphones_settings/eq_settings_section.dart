import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../headphones/headphones_data_objects.dart';
import '../../../../headphones/headphones_base.dart';

class EqSettingsSection extends StatelessWidget {
  final HeadphonesBase headphones;

  const EqSettingsSection({Key? key, required this.headphones}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Массив режимов эквалайзера
    final eqModes = [
      {'title': l.eqDefault, 'mode': HeadphonesEqMode.nothing, 'icon': Icons.music_note_outlined},
      {'title': l.eqBassBoost, 'mode': HeadphonesEqMode.bass, 'icon': Icons.speaker_outlined},
      {'title': l.eqTrebleBoost, 'mode': HeadphonesEqMode.treble, 'icon': Icons.multitrack_audio_outlined},
      {'title': l.eqVoices, 'mode': HeadphonesEqMode.voice, 'icon': Icons.record_voice_over_outlined},
    ];

    return StreamBuilder<HeadphonesEqMode>(
      stream: headphones.eqMode, // Получаем текущий эквалайзер
      initialData: headphones.eqMode.valueOrNull ?? HeadphonesEqMode.nothing,
      builder: (context, eqModeSnapshot) {
        final selectedMode = eqModeSnapshot.data ?? HeadphonesEqMode.nothing;
        final colorScheme = Theme.of(context).colorScheme;

        return Column(
          children: [
            // GridView для эквалайзер режимов
            Container(
              height: MediaQuery.of(context).size.height * 0.5, // 60% от высоты экрана
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Количество столбцов
                  mainAxisSpacing: 16, // Вертикальный отступ
                  crossAxisSpacing: 16, // Горизонтальный отступ
                  childAspectRatio: 1, // Пропорции карточек
                ),
                itemCount: eqModes.length,
                itemBuilder: (context, index) {
                  final mode = eqModes[index];
                  final isSelected = selectedMode == mode['mode'];

                  return GestureDetector(
                    onTap: () {
                      // Обновляем режим эквалайзера
                      headphones.setEqMode(mode['mode'] as HeadphonesEqMode);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? colorScheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            mode['icon'] as IconData,
                            size: 48,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mode['title'] as String, // Локализованный текст
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Добавляем SizedBox с маленьким отступом
            const SizedBox(height: 1), // Задаём небольшой отступ
            // Добавляем Card с текстом
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16), // Отступы по бокам
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l.eqNote,
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
