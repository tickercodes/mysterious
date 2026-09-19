import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class FilesScreen extends StatelessWidget {
  const FilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final puzzle = game.currentFiles;
    final done = switch (game.episode) {
      2 => game.flags.contains('recoveredCalder'),
      3 => game.flags.contains('boundRoom9'),
      4 => game.flags.contains('alloyMelted'),
      _ => game.flags.contains('recoveredSable'),
    };
    return Column(
      children: [
        const AppBarMini(title: 'Files'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              if (!game.onVera && game.episode == 1)
                Text(
                  'sable_thread.dat is on the editor\'s phone. Switch to Vera, then recover it.',
                  style: GoogleFonts.cormorantGaramond(fontSize: 18, color: InkColors.paperDim),
                )
              else ...[
                Text(
                  puzzle.label,
                  style: GoogleFonts.dmSans(color: InkColors.brass, fontSize: 12, letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  done ? 'Recovery complete. Follow the red task bar.' : puzzle.hint,
                  style: GoogleFonts.cormorantGaramond(fontSize: 18, color: InkColors.paperDim),
                ),
                if (game.filesError != null) ...[
                  const SizedBox(height: 8),
                  Text(game.filesError!, style: GoogleFonts.dmSans(color: InkColors.blood)),
                ],
                const SizedBox(height: 16),
                for (var i = 0; i < puzzle.fragments.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: done ? null : () => game.recoverTap(i),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: game.fragmentTap.contains(i)
                              ? InkColors.teal
                              : InkColors.newsroom.withValues(alpha: 0.9),
                          border: Border.all(
                            color: game.fragmentTap.contains(i) ? InkColors.brass : InkColors.teal,
                          ),
                        ),
                        child: Text(
                          '${String.fromCharCode(65 + i)}.  ${puzzle.fragments[i]}',
                          style: GoogleFonts.dmSans(color: InkColors.paper, height: 1.3),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
