import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/night_desk_theme.dart';
import '../widgets/chrome.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final posts = game.visibleFeed();
    return Column(
      children: [
        const AppBarMini(title: 'Pier Feed'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Marrow Bay posts what it is allowed to. The rest is in the grain.',
            style: GoogleFonts.dmSans(fontSize: 12, color: InkColors.paperDim, decoration: TextDecoration.none),
          ),
        ),
        Expanded(
          child: posts.isEmpty
              ? Center(
                  child: Text(
                    'No posts yet. The town is pretending to sleep.',
                    style: GoogleFonts.cormorantGaramond(fontSize: 18, color: InkColors.paperDim),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    final post = posts[posts.length - 1 - i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: InkColors.newsroom.withValues(alpha: 0.9),
                        border: Border.all(color: InkColors.teal),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${post.author}  ·  ${post.handle}',
                            style: GoogleFonts.dmSans(fontSize: 12, color: InkColors.brass, decoration: TextDecoration.none),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.body,
                            style: GoogleFonts.cormorantGaramond(fontSize: 18, height: 1.35, color: InkColors.paper),
                          ),
                          if (post.image != null) ...[
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(post.image!, height: 120, width: double.infinity, fit: BoxFit.cover),
                            ),
                          ],
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
