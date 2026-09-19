import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/story.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class EditionsScreen extends StatelessWidget {
  const EditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Column(
      children: [
        const AppBarMini(title: 'Editions'),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: Story.editions.length + (game.campaignComplete ? 1 : 0),
            itemBuilder: (context, i) {
              if (game.campaignComplete && i == Story.editions.length) {
                final title = switch (game.ending) {
                  'spike' => 'You printed weather.',
                  'crowe' => 'You fed the mayor to the tray.',
                  _ => 'You melted the desk.',
                };
                final body = switch (game.ending) {
                  'spike' => 'June is tide again. You still have a job. The charter will eat in March.',
                  'crowe' => 'Harlan is alloy. Sable has a yesterday. You have a byline nobody will run.',
                  _ => 'The harbor is only water. June can be photographed from the side. Go inland.',
                };
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: InkColors.blood),
                    color: InkColors.newsroom.withValues(alpha: 0.88),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LAST LINE', style: GoogleFonts.dmSans(fontSize: 10, letterSpacing: 2, color: InkColors.blood)),
                      Text(title, style: GoogleFonts.cormorantGaramond(fontSize: 24, color: InkColors.paper)),
                      Text(body, style: GoogleFonts.dmSans(color: InkColors.paperDim, fontSize: 13)),
                    ],
                  ),
                );
              }
              final e = Story.editions[i];
              final unlocked = game.episode >= e.id || (e.id == 1 && game.flags.contains('started'));
              final closed = game.episode > e.id || (e.id == 4 && game.campaignComplete);
              return Opacity(
                opacity: unlocked ? 1 : 0.45,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: unlocked ? InkColors.brass : InkColors.teal),
                    color: InkColors.newsroom.withValues(alpha: 0.88),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unlocked ? 'EDITION ${e.id}${closed ? '  ·  CLOSED' : '  ·  LIVE'}' : 'LOCKED  ·  EDITION ${e.id}',
                        style: GoogleFonts.dmSans(fontSize: 10, letterSpacing: 2, color: InkColors.brass),
                      ),
                      Text(e.title, style: GoogleFonts.cormorantGaramond(fontSize: 24, color: InkColors.paper)),
                      Text(e.blurb, style: GoogleFonts.dmSans(color: InkColors.paperDim, fontSize: 13)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
