import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/assets.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Column(
      children: [
        const AppBarMini(title: 'Case board'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Edition ${game.episode}  ·  ${game.matchedPairs.length}/${game.boardPairTarget} pairs.',
            style: GoogleFonts.dmSans(color: InkColors.paperDim),
          ),
        ),
        if (game.boardError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(game.boardError!, style: GoogleFonts.dmSans(color: InkColors.blood, fontSize: 13)),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset(GameAssets.caseBoard, height: 100, fit: BoxFit.cover),
              const SizedBox(height: 12),
              for (final card in game.currentBoard)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => game.tapBoard(card.id),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: game.matchedPairs.contains(card.pair)
                            ? InkColors.teal
                            : InkColors.newsroom.withValues(alpha: 0.92),
                        border: Border.all(
                          color: game.boardSelected == card.id ? InkColors.blood : InkColors.brassDim,
                          width: game.boardSelected == card.id ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        card.text,
                        style: GoogleFonts.dmSans(color: InkColors.paper, height: 1.3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
