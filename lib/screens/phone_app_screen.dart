import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class PhoneAppScreen extends StatefulWidget {
  const PhoneAppScreen({super.key});

  @override
  State<PhoneAppScreen> createState() => _PhoneAppScreenState();
}

class _PhoneAppScreenState extends State<PhoneAppScreen> {
  String digits = '';

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    if (game.app == AppId.call) return const _CallView();

    final tab = game.app == AppId.voicemail
        ? 2
        : game.app == AppId.recents
            ? 1
            : 0;

    return Column(
      children: [
        const AppBarMini(title: 'Phone'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _tab('Keypad', tab == 0, () => game.openApp(AppId.phone)),
              _tab('Recents', tab == 1, () => game.openApp(AppId.recents)),
              _tab('VM', tab == 2, () => game.openApp(AppId.voicemail)),
            ],
          ),
        ),
        Expanded(
          child: tab == 2
              ? const _Voicemail()
              : tab == 1
                  ? _Recents(onDial: (n) => game.dial(n))
                  : _keypad(game),
        ),
      ],
    );
  }

  Widget _tab(String label, bool on, VoidCallback tap) {
    return Expanded(
      child: TextButton(
        onPressed: tap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.dmSans(
            color: on ? InkColors.brass : InkColors.paperDim,
            fontWeight: on ? FontWeight.w700 : FontWeight.w400,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _keypad(GameController game) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 4, 28, 12),
      child: Column(
        children: [
          Text(
            digits.isEmpty ? 'Enter a number' : digits,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(
              fontSize: 22,
              color: InkColors.paper,
              letterSpacing: 1.4,
              decoration: TextDecoration.none,
            ),
          ),
          if (game.flags.contains('listenedVoicemail'))
            TextButton(
              onPressed: () => game.dial(EpisodeCopy.ellisNumber),
              child: Text(
                'Ellis Ward  ·  207-555-1999',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(color: InkColors.brass, decoration: TextDecoration.none),
              ),
            ),
          if (game.flags.contains('recoveredCalder'))
            TextButton(
              onPressed: () => game.dial(EpisodeCopy.calderNumber),
              child: Text(
                'Ruth Calder  ·  207-555-1102',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(color: InkColors.brass, decoration: TextDecoration.none),
              ),
            ),
          if (game.flags.contains('visitedCharter') || game.episode >= 3)
            TextButton(
              onPressed: () => game.dial(EpisodeCopy.harlanNumber),
              child: Text(
                'Harlan Crowe  ·  207-555-0100',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(color: InkColors.brass, decoration: TextDecoration.none),
              ),
            ),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.85,
              children: [
                for (final k in keys)
                  GestureDetector(
                    onTap: () => setState(() => digits += k),
                    child: Center(
                      child: Text(
                        k,
                        style: GoogleFonts.dmSans(fontSize: 24, color: InkColors.paper, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: digits.isEmpty ? null : () => setState(() => digits = digits.substring(0, digits.length - 1)),
                icon: const Icon(Icons.backspace_outlined, color: InkColors.paperDim),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                backgroundColor: const Color(0xFF2E7D4F),
                onPressed: digits.isEmpty ? null : () => game.dial(digits),
                child: const Icon(Icons.phone, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Recents extends StatelessWidget {
  const _Recents({required this.onDial});

  final ValueChanged<String> onDial;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    if (game.recents.isEmpty) {
      return Center(
        child: Text('No calls yet.', style: GoogleFonts.dmSans(color: InkColors.paperDim)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: game.recents.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x22E6D7C3)),
      itemBuilder: (context, i) {
        final n = game.recents[i];
        final label = n == EpisodeCopy.ellisNumber
            ? 'Ellis Ward'
            : n == EpisodeCopy.calderNumber
                ? 'Ruth Calder'
                : n == EpisodeCopy.harlanNumber
                    ? 'Harlan Crowe'
                    : n;
        return ListTile(
          onTap: () => onDial(n),
          leading: const Icon(Icons.phone_callback, color: InkColors.brass),
          title: Text(label, style: GoogleFonts.dmSans(color: InkColors.paper)),
          subtitle: Text(n, style: GoogleFonts.dmSans(color: InkColors.paperDim, fontSize: 12)),
        );
      },
    );
  }
}

class _Voicemail extends StatelessWidget {
  const _Voicemail();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final notes = game.visibleVoicemail();
    if (notes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No new messages.', style: GoogleFonts.dmSans(color: InkColors.paperDim)),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final vm in notes) ...[
          Text('${vm.from.toUpperCase()}  ·  ${vm.time}', style: GoogleFonts.dmSans(color: InkColors.brass, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            vm.body,
            style: GoogleFonts.cormorantGaramond(fontSize: 18, height: 1.4, color: InkColors.paper),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _CallView extends StatelessWidget {
  const _CallView();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final script = game.callScript;
    final name = switch (script) {
      'ellis' => 'Ellis Ward',
      'unknown' => 'UNKNOWN',
      'calder' => 'Ruth Calder',
      'harlan' => 'Harlan Crowe',
      _ => 'No signal',
    };
    final body = switch (script) {
      'ellis' =>
        'Don\'t come to the press room. They\'re hosing the tray. The site she hid is ledger.early — type it exactly. No www. If you print what you find, Harlan will bury you next to June.',
      'unknown' => 'You do not call the early edition. It calls you. Hang up.',
      'calder' =>
        'I set a child in Caslon and called it a correction. Job ticket 1102 is November 2. The proof slip is job1102.ledger. Vera\'s password is the typeface. I will still sit down at 6:02. The charter does not take warnings. Set me in a font that is not mine.',
      'harlan' =>
        'My grandfather bound water with a desk. charter.ledger — read it. You can spike the girl, feed me to the tray, or melt 1894. Only one of those lets the harbor stay a harbor. I sleep better if you pick wrong.',
      _ => 'Marrow Bay only answers numbers that have already been printed.',
    };

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            'CONNECTED',
            style: GoogleFonts.dmSans(
              letterSpacing: 3,
              color: InkColors.brass,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 36,
              color: InkColors.paper,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: 16, height: 1.4, color: InkColors.paperDim, decoration: TextDecoration.none),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: InkColors.blood,
            onPressed: game.hangUp,
            child: const Icon(Icons.call_end, color: Colors.white),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
