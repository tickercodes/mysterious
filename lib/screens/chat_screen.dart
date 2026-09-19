import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final chatId = game.openChatId;
    if (chatId == null) return const SizedBox.shrink();
    final contact = _contactFor(chatId);
    final lines = game.thread(chatId);
    final mine = game.onVera ? 'vera' : 'rowan';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 12, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => game.openApp(AppId.messages),
                icon: const Icon(Icons.chevron_left, color: InkColors.brass),
              ),
              CircleAvatar(
                radius: 16,
                backgroundImage: contact.avatar == null ? null : AssetImage(contact.avatar!),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.name, style: GoogleFonts.dmSans(color: InkColors.paper, fontWeight: FontWeight.w600)),
                    Text(contact.subtitle, style: GoogleFonts.dmSans(color: InkColors.paperDim, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            itemCount: lines.length,
            itemBuilder: (context, i) {
              final line = lines[i];
              if (line.system) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    line.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(fontSize: 11, color: InkColors.brassDim),
                  ),
                );
              }
              final isMine = line.senderId == mine || (mine == 'rowan' && line.senderId == 'rowan');
              return Align(
                alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMine ? InkColors.teal : InkColors.newsroom.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (contact.group && !isMine)
                        Text(
                          Contacts.byId(line.senderId).name,
                          style: GoogleFonts.dmSans(fontSize: 11, color: InkColors.brass),
                        ),
                      if (line.image != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(line.image!, fit: BoxFit.cover),
                        ),
                        if (line.text.isNotEmpty) const SizedBox(height: 8),
                      ],
                      if (line.text.isNotEmpty)
                        Text(
                          line.text,
                          style: GoogleFonts.dmSans(fontSize: 15, height: 1.35, color: InkColors.paper),
                        ),
                      const SizedBox(height: 4),
                      Text(line.time, style: GoogleFonts.dmSans(fontSize: 10, color: InkColors.paperDim)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (game.choices != null && game.choiceChatId == chatId)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Column(
              children: [
                for (final c in game.choices!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: InkColors.paper,
                          side: const BorderSide(color: InkColors.brass),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        ),
                        onPressed: () => game.choose(c),
                        child: Text(c.label, style: GoogleFonts.dmSans(fontSize: 13, height: 1.3)),
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }

  Contact _contactFor(String chatId) {
    switch (chatId) {
      case 'unknown':
        return Contacts.unknown;
      case 'vera':
        return Contacts.vera;
      case 'ellis':
        return Contacts.ellis;
      case 'camille':
      case 'camille_v':
        return Contacts.camille;
      case 'harlan':
        return Contacts.harlan;
      case 'sable':
        return Contacts.sable;
      case 'calder':
        return Contacts.calder;
      case 'masthead':
        return Contacts.masthead;
      default:
        return Contacts.rowan;
    }
  }
}
