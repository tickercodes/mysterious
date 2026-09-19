import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/assets.dart';
import '../data/models.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(GameAssets.keyArt, fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x88000000), Color(0x00000000), Color(0xF207090A)],
              stops: [0, 0.34, 0.78],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  EpisodeCopy.series.toUpperCase(),
                  style: GoogleFonts.specialElite(fontSize: 11, letterSpacing: 6, color: InkColors.brass),
                ),
                const Spacer(),
                Text(
                  EpisodeCopy.title,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 52,
                    height: 0.9,
                    fontWeight: FontWeight.w600,
                    color: InkColors.paper,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  EpisodeCopy.tagline,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: InkColors.paperDim,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Four editions  ·  Marrow Bay, Maine',
                  style: GoogleFonts.dmSans(fontSize: 11, letterSpacing: 0.8, color: InkColors.brassDim),
                ),
                const SizedBox(height: 28),
                _Btn(
                  label: game.flags.contains('started') ? 'Return to the phones' : 'Unlock the phones',
                  filled: true,
                  onTap: () {
                    game.start();
                    Navigator.pushNamed(context, '/phone');
                  },
                ),
                const SizedBox(height: 10),
                _Btn(
                  label: 'How to investigate',
                  filled: false,
                  onTap: () => Navigator.pushNamed(context, '/how'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InkColors.voidBlack,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          children: [
            AppBarMini(title: 'How to investigate', onBack: () => Navigator.pop(context)),
            Text(
              'You are Rowan Hale. An unknown sender will put two phones in your hands: yours, and a dead editor\'s. The early edition does not predict death. It collects names.',
              style: GoogleFonts.cormorantGaramond(fontSize: 22, color: InkColors.paper, height: 1.35),
            ),
            const SizedBox(height: 16),
            _rule('Follow the red TASK bar. Tap it to jump. HINT gives you three pushes per task.'),
            _rule('Answer chats. Your wording changes what they confess — and how the last line reads.'),
            _rule('Switch phones. Vera\'s device is locked. The PIN is a time, not a death.'),
            _rule('Type URLs. This browser does not search. Chats, voicemail, and Case hide the addresses.'),
            _rule('Recover files in compositor order. Match proofs. Read Pier Feed for the town\'s official lies.'),
            _rule('Four editions. The last line of your obituary stays blank until you set it. Nothing is an energy gate.'),
          ],
        ),
      ),
    );
  }

  Widget _rule(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text('—  $text', style: GoogleFonts.dmSans(fontSize: 15, height: 1.4, color: InkColors.paperDim)),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({required this.label, required this.onTap, required this.filled});

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? InkColors.brass : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: InkColors.brass, width: 1.2)),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.specialElite(
              fontSize: 12,
              letterSpacing: 2.4,
              color: filled ? InkColors.ink : InkColors.brass,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
