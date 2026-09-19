import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';

class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF030405),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430, maxHeight: 920),
          child: AspectRatio(
            aspectRatio: 9 / 19.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: InkColors.brassDim.withValues(alpha: 0.4), width: 2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: Row(
        children: [
          Text(
            game.clock,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: InkColors.paper,
              decoration: TextDecoration.none,
            ),
          ),
          const Spacer(),
          Text(
            game.onVera ? 'VQ' : 'RH',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: InkColors.brass,
              letterSpacing: 1.4,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.signal_cellular_alt, size: 14, color: InkColors.paperDim),
          const SizedBox(width: 4),
          const Icon(Icons.battery_3_bar, size: 16, color: InkColors.paperDim),
        ],
      ),
    );
  }
}

class TaskBanner extends StatelessWidget {
  const TaskBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return GestureDetector(
      onTap: () {
        final game = context.read<GameController>();
        final target = game.highlightApp;
        if (target == 'messages') game.openApp(AppId.messages);
        if (target == 'files') game.openApp(AppId.files);
        if (target == 'phone') game.openApp(AppId.phone);
        if (target == 'browser') game.openApp(AppId.browser);
        if (target == 'notes') game.openApp(AppId.notes);
        if (target == 'board') game.openApp(AppId.board);
        if (target == 'feed') game.openApp(AppId.feed);
        if (target == 'editions') game.openApp(AppId.editions);
        if (target == 'switch') game.switchPhone();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: InkColors.blood.withValues(alpha: 0.22),
          border: Border.all(color: InkColors.blood.withValues(alpha: 0.7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'TASK',
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    letterSpacing: 2.4,
                    color: InkColors.brass,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: game.useHint,
                  child: Text(
                    game.hintsUsedOnTask >= 3 ? 'HINTS USED' : 'HINT  ·  ${3 - game.hintsUsedOnTask}',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: InkColors.brass,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              game.task,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 13.5,
                height: 1.3,
                color: InkColors.paper,
                decoration: TextDecoration.none,
              ),
            ),
            if (game.lastHint != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  game.lastHint!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 15,
                    height: 1.25,
                    color: InkColors.brass,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppBarMini extends StatelessWidget {
  const AppBarMini({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => context.read<GameController>().goHome(),
            icon: const Icon(Icons.chevron_left, color: InkColors.brass),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: InkColors.paper,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
