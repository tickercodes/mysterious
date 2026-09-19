import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';
import 'board_screen.dart';
import 'browser_screen.dart';
import 'chat_screen.dart';
import 'editions_screen.dart';
import 'feed_screen.dart';
import 'files_screen.dart';
import 'gallery_screen.dart';
import 'messages_screen.dart';
import 'notes_screen.dart';
import 'phone_app_screen.dart';

class PhoneShell extends StatelessWidget {
  const PhoneShell({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Scaffold(
      backgroundColor: InkColors.voidBlack,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(game.wallpaper, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.38)),
          SafeArea(
            child: Column(
              children: [
                const StatusBar(),
                if (game.app != AppId.call) const TaskBanner(),
                Expanded(child: _body(game)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(GameController game) {
    if (game.onVera && !game.veraUnlocked) return const _LockScreen();
    switch (game.app) {
      case AppId.home:
        return const _HomeGrid();
      case AppId.messages:
        return const MessagesScreen();
      case AppId.chat:
        return const ChatScreen();
      case AppId.gallery:
        return const GalleryScreen();
      case AppId.notes:
        return const NotesScreen();
      case AppId.phone:
      case AppId.recents:
      case AppId.voicemail:
      case AppId.call:
        return const PhoneAppScreen();
      case AppId.browser:
        return const BrowserScreen();
      case AppId.files:
        return const FilesScreen();
      case AppId.board:
        return const BoardScreen();
      case AppId.editions:
        return const EditionsScreen();
      case AppId.feed:
        return const FeedScreen();
    }
  }
}

class _HomeGrid extends StatelessWidget {
  const _HomeGrid();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final apps = <_AppSpec>[
      _AppSpec('messages', 'Messages', Icons.chat_bubble, AppId.messages, game.unread.isNotEmpty),
      _AppSpec('gallery', 'Photos', Icons.photo, AppId.gallery, false),
      _AppSpec('phone', 'Phone', Icons.phone, AppId.phone, game.highlightApp == 'phone'),
      _AppSpec('notes', 'Notes', Icons.menu_book, AppId.notes, false),
      _AppSpec('browser', 'Browser', Icons.public, AppId.browser, false),
      _AppSpec('files', 'Files', Icons.folder, AppId.files, game.highlightApp == 'files'),
      _AppSpec('board', 'Case', Icons.hub, AppId.board, game.highlightApp == 'board'),
      _AppSpec('feed', 'Feed', Icons.forum, AppId.feed, game.feedHasNew),
      _AppSpec('editions', 'Editions', Icons.newspaper, AppId.editions, game.campaignComplete),
    ];

    Widget row(List<_AppSpec> specs) {
      return Row(
        children: [
          for (final spec in specs)
            Expanded(
              child: _AppIcon(
                spec: spec,
                lit: game.highlightApp == spec.key,
                onTap: () => game.openApp(spec.app),
              ),
            ),
        ],
      );
    }

    return DefaultTextStyle.merge(
      style: const TextStyle(
        decoration: TextDecoration.none,
        decorationColor: Colors.transparent,
        decorationThickness: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
        child: Column(
          children: [
            Text(
              game.clock,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 44,
                height: 1,
                color: InkColors.paper,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              game.ownerName.toUpperCase(),
              style: GoogleFonts.dmSans(
                fontSize: 11,
                letterSpacing: 3,
                color: InkColors.brass,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    row(apps.sublist(0, 3)),
                    const SizedBox(height: 12),
                    row(apps.sublist(3, 6)),
                    const SizedBox(height: 12),
                    row(apps.sublist(6, 9)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: game.switchPhone,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  border: Border.all(
                    color: game.highlightApp == 'switch' ? InkColors.blood : Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                child: Text(
                  game.onVera ? 'SWITCH TO ROWAN\'S PHONE' : 'SWITCH TO VERA\'S PHONE',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: InkColors.brass,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSpec {
  const _AppSpec(this.key, this.label, this.icon, this.app, this.badge);
  final String key;
  final String label;
  final IconData icon;
  final AppId app;
  final bool badge;
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.spec, required this.lit, required this.onTap});

  final _AppSpec spec;
  final bool lit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: InkColors.newsroom.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: lit ? InkColors.blood : Colors.white.withValues(alpha: 0.12),
                width: lit ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Center(child: Icon(spec.icon, color: InkColors.paper, size: 22)),
                if (spec.badge || lit)
                  const Positioned(
                    right: 4,
                    top: 4,
                    child: SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: InkColors.blood, shape: BoxShape.circle),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            spec.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              height: 1.15,
              color: InkColors.paperDim,
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
      child: Column(
        children: [
          const CircleAvatar(radius: 32, backgroundColor: InkColors.teal, child: Icon(Icons.lock, color: InkColors.paper)),
          const SizedBox(height: 10),
          Text(
            'Vera Quinn',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              color: InkColors.paper,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            'Enter passcode',
            style: GoogleFonts.dmSans(fontSize: 13, color: InkColors.paperDim, decoration: TextDecoration.none),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final on = i < game.pinBuffer.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: on ? InkColors.brass : Colors.transparent,
                  border: Border.all(color: InkColors.brass),
                ),
              );
            }),
          ),
          if (game.pinError.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              game.pinError,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 13, color: InkColors.blood, decoration: TextDecoration.none),
            ),
          ],
          const SizedBox(height: 8),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.7,
              children: [
                for (final k in keys)
                  GestureDetector(
                    onTap: k.isEmpty
                        ? null
                        : () {
                            if (k == '⌫') {
                              game.pinDelete();
                            } else {
                              game.typePin(k);
                            }
                          },
                    child: Center(
                      child: Text(
                        k,
                        style: GoogleFonts.dmSans(fontSize: 26, color: InkColors.paper, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: game.switchPhone,
            child: Text(
              'Back to Rowan\'s phone',
              style: GoogleFonts.dmSans(color: InkColors.brass, decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}
