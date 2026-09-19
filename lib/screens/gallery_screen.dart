import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/assets.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final shots = <(String, String, String)>[
      (GameAssets.harbor, 'Marrow Bay', 'Always'),
      if (game.flags.contains('openedUnknown')) (GameAssets.obituary, 'Early edition', '2:17 AM'),
      if (game.flags.contains('openedUnknown')) (GameAssets.evidenceTable, 'Press room floor', 'Unknown sent this'),
      if (game.flags.contains('veraDead')) (GameAssets.printRoom, 'Last photo from Vera', '6:02 AM'),
      if (game.flags.contains('visitedEarly')) (GameAssets.twinsPhoto, '11/02/99', 'ledger.early'),
      if (game.flags.contains('visitedEarly')) (GameAssets.archives, 'Stolen drawer', '1999'),
      if (game.flags.contains('calledCalder')) (GameAssets.archives, 'Composing room', 'Font closet'),
      if (game.flags.contains('visitedRoom9')) (GameAssets.archives, 'Ninth window', 'room9.ledger'),
      if (game.flags.contains('visitedCharter')) (GameAssets.newsroom, 'The Crowe desk', '1894'),
      if (game.flags.contains('boundRoom9')) (GameAssets.sable, 'June Quinn', 'Uncorrected proof'),
      if (game.campaignComplete) (GameAssets.obituary, 'Last line', game.ending ?? 'set'),
    ];

    return Column(
      children: [
        const AppBarMini(title: 'Photos'),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: shots.length,
            itemBuilder: (context, i) {
              final shot = shots[i];
              return GestureDetector(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => Dialog(
                      backgroundColor: InkColors.voidBlack,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(shot.$1, fit: BoxFit.cover),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '${shot.$2}\n${shot.$3}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(color: InkColors.paper),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(shot.$1, fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black54,
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          shot.$2,
                          style: GoogleFonts.dmSans(fontSize: 11, color: InkColors.paper),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
