import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/models.dart';
import 'screens/phone_shell.dart';
import 'screens/title_screen.dart';
import 'state/game_controller.dart';
import 'theme/night_desk_theme.dart';
import 'widgets/chrome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NightDeskApp());
}

class NightDeskApp extends StatelessWidget {
  const NightDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(),
      child: MaterialApp(
        title: EpisodeCopy.title,
        debugShowCheckedModeBanner: false,
        theme: NightDeskTheme.dark,
        builder: (context, child) {
          final width = MediaQuery.sizeOf(context).width;
          final page = DefaultTextStyle.merge(
            style: const TextStyle(
              decoration: TextDecoration.none,
              decorationColor: Colors.transparent,
              decorationThickness: 0,
            ),
            child: child ?? const SizedBox.shrink(),
          );
          if (width <= 520) return page;
          return PhoneFrame(child: page);
        },
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final Widget page = switch (settings.name) {
            '/' => const TitleScreen(),
            '/phone' => const PhoneShell(),
            '/how' => const HowToScreen(),
            _ => const TitleScreen(),
          };
          return PageRouteBuilder<void>(
            settings: settings,
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    );
  }
}
