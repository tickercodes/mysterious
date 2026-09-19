import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final page = game.currentDiary;
    final unlocked = game.unlockedDiaries();
    final currentOpen = game.episode == 4
        ? game.flags.contains('alloyMelted') || game.diaryOpen
        : (game.episode == 1 && game.diaryOpen) ||
            (game.episode == 2 && game.flags.contains('diary2')) ||
            (game.episode == 3 && game.flags.contains('diary3'));

    return Column(
      children: [
        const AppBarMini(title: 'Notes'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Text(
                game.onVera ? 'Private notebooks' : 'Night desk — Rowan',
                style: GoogleFonts.cormorantGaramond(fontSize: 26, color: InkColors.paper),
              ),
              const SizedBox(height: 12),
              if (!game.onVera)
                Text(
                  'If the unknown sender is right, do not look at the press after 2:17.\nI looked.\nVera laughed.\nThe watch did not.\n\nPIN hint: the watch stopped at the beginning, not the ending.\n\nLater: I held a rope in 1999. I thought it was a drowning.',
                  style: GoogleFonts.cormorantGaramond(fontSize: 18, height: 1.4, color: InkColors.paperDim),
                )
              else ...[
                for (final old in unlocked) ...[
                  Text(old.title, style: GoogleFonts.dmSans(fontSize: 12, letterSpacing: 1.4, color: InkColors.brass)),
                  const SizedBox(height: 6),
                  Text(old.body, style: GoogleFonts.cormorantGaramond(fontSize: 17, height: 1.45, color: InkColors.paper)),
                  const SizedBox(height: 18),
                ],
                if (!currentOpen) ...[
                  Text(page.title, style: GoogleFonts.dmSans(fontSize: 12, letterSpacing: 1.4, color: InkColors.brass)),
                  const SizedBox(height: 8),
                  Text(page.hint, style: GoogleFonts.cormorantGaramond(fontSize: 18, color: InkColors.paperDim)),
                  if (page.password.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (v) => game.diaryInput = v,
                      onSubmitted: (_) => game.submitDiary(),
                      style: GoogleFonts.dmSans(color: InkColors.paper),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.dmSans(color: InkColors.paperDim),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: InkColors.brassDim)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: game.submitDiary,
                      style: ElevatedButton.styleFrom(backgroundColor: InkColors.brass, foregroundColor: InkColors.ink),
                      child: const Text('UNLOCK'),
                    ),
                  ],
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
