import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/assets.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class BrowserScreen extends StatelessWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Column(
      children: [
        const AppBarMini(title: 'Browser'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            onChanged: (v) => game.urlInput = v,
            onSubmitted: (_) => game.submitUrl(),
            style: GoogleFonts.dmSans(color: InkColors.paper, fontSize: 14),
            decoration: InputDecoration(
              prefixText: 'https://  ',
              prefixStyle: GoogleFonts.dmSans(color: InkColors.brass),
              hintText: 'type a URL',
              hintStyle: GoogleFonts.dmSans(color: InkColors.paperDim),
              filled: true,
              fillColor: InkColors.newsroom,
              suffixIcon: IconButton(
                onPressed: game.submitUrl,
                icon: const Icon(Icons.arrow_forward, color: InkColors.brass),
              ),
            ),
          ),
        ),
        Expanded(child: _page(game)),
      ],
    );
  }

  Widget _page(GameController game) {
    Widget article(String kicker, String title, String body, {String? image}) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(kicker, style: GoogleFonts.specialElite(fontSize: 12, letterSpacing: 2, color: InkColors.blood)),
          Text(title, style: GoogleFonts.cormorantGaramond(fontSize: 28, color: InkColors.paper)),
          const SizedBox(height: 12),
          if (image != null) ...[
            Image.asset(image),
            const SizedBox(height: 12),
          ],
          Text(body, style: GoogleFonts.cormorantGaramond(fontSize: 18, height: 1.4, color: InkColors.paperDim)),
        ],
      );
    }

    return switch (game.browserPage) {
      'early' => article(
          'THE MARROW BAY LEDGER',
          'Early edition archive',
          '11/02/99  —  SPIKED\nA drowning at the municipal pier was rewritten as high tide. The victim\'s name was razored from the plate. Remaining letters in the alloy: J U N E.\n\nEditor: V. Quinn. Paid notice: H. Crowe.\n\nThis page is not indexed. If you are reading it, the press already knows your name.',
          image: GameAssets.twinsPhoto,
        ),
      'calder' => article(
          'COMPOSING ROOM',
          'Job ticket 1102',
          'Job ticket 1102 is not in the log. It is November 2. Ruth Calder locked the font closet after a girl was set in Caslon instead of water.\n\nComposing-room voicemail: 207-555-1102.\nPassword Vera left on the plate: the typeface.\n\nThe ninth window is not in this building\'s brick. It is in the archive wall the fire map skipped.',
          image: GameAssets.archives,
        ),
      'room9' => article(
          'UNBOUND',
          'Room 9',
          game.flags.contains('visitedRoom9') && game.episode >= 3
              ? 'There is a hook. There is a key. There is a window that is a page.\n\nBind the intern copy in Files: room, hook, yesterday, spike.\n\nIf you are Rowan Hale, you already held the other end of this sentence in 1999.'
              : 'There is no HTTP here.\nOnly a key on a hook\nand a window the fire map forgot.',
          image: GameAssets.archives,
        ),
      'charter' => article(
          'MARROW BAY  ·  1894',
          'The Crowe Charter',
          'The harbor is bound to a desk. Each dawn, one obituary must sit on that desk before the tide turns, or the water comes for every yesterday in town.\n\nThe Crowe family keeps the tray. They do not keep the dead. They keep the names.\n\nA spiked story is still a feeding. A razored name is still a meal. Unprinting the desk is the only hunger that ends.',
          image: GameAssets.newsroom,
        ),
      'spike' => article(
          'SPECIAL EDITION',
          'Weather',
          'June Quinn returns to high tide. Sable is removed from the roster. You keep the night desk. In March the tray will ask for a tourist.\n\nThe moth goes quiet. That is not the same as gone.',
          image: GameAssets.harbor,
        ),
      'crowe' => article(
          'SPECIAL EDITION',
          'Harlan Crowe, 6:02',
          'The mayor is in the alloy. The harbor stays "bound." June keeps a yesterday. You have a byline nobody will print.\n\nCamille will try. Harlan will not answer.',
          image: GameAssets.printRoom,
        ),
      'kill' => article(
          'SPECIAL EDITION',
          'The desk is slag',
          '1894, 1999, 2:17, 6:02 — melted in order. The harbor is only water. June Quinn can be photographed from the side. Rowan Hale\'s last line is a resignation, not an obituary.\n\nBurn the moth. Go inland.',
          image: GameAssets.evidenceTable,
        ),
      'killlocked' => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'The metal is still bound.\nMelt 1894, 1999, 2:17, 6:02 in Files first.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(fontSize: 22, color: InkColors.paper),
            ),
          ),
        ),
      'tooearly' => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'The last line is not blank yet.\nFinish the case board of this edition.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(fontSize: 22, color: InkColors.paper),
            ),
          ),
        ),
      '404' => Center(
          child: Text('No such edition.', style: GoogleFonts.dmSans(color: InkColors.paperDim)),
        ),
      _ => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'This browser does not search.\nIt only opens what you already found.\n\nTry a URL from a chat, a voicemail, or the case board.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(fontSize: 20, color: InkColors.paperDim),
            ),
          ),
        ),
    };
  }
}
