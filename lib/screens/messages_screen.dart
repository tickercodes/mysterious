import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final rows = game.inbox();
    return Column(
      children: [
        const AppBarMini(title: 'Messages'),
        Expanded(
          child: ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x22E6D7C3)),
            itemBuilder: (context, i) {
              final row = rows[i];
              final lines = game.thread(row.chatId);
              final last = lines.isEmpty ? 'No messages' : lines.last.text;
              final unread = game.unread.contains(row.chatId);
              return ListTile(
                onTap: () => game.openChat(row.chatId),
                leading: CircleAvatar(
                  backgroundImage: row.contact.avatar == null ? null : AssetImage(row.contact.avatar!),
                  backgroundColor: InkColors.teal,
                ),
                title: Text(
                  row.contact.name,
                  style: GoogleFonts.dmSans(
                    color: InkColors.paper,
                    fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(color: InkColors.paperDim, fontSize: 13),
                ),
                trailing: unread
                    ? const CircleAvatar(radius: 6, backgroundColor: InkColors.blood)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
