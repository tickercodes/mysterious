import 'assets.dart';

class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.subtitle,
    this.avatar,
    this.number,
    this.group = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final String? avatar;
  final String? number;
  final bool group;
}

class ChatLine {
  ChatLine({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.text = '',
    this.image,
    this.system = false,
    this.time = '',
  });

  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String? image;
  final bool system;
  final String time;
}

class ReplyChoice {
  const ReplyChoice({
    required this.id,
    required this.label,
    required this.playerText,
    this.flag,
  });

  final String id;
  final String label;
  final String playerText;
  final String? flag;
}

class BoardCard {
  const BoardCard({required this.id, required this.text, required this.pair});

  final String id;
  final String text;
  final String pair;
}

class DiaryPage {
  const DiaryPage({
    required this.id,
    required this.title,
    required this.hint,
    required this.password,
    required this.body,
  });

  final String id;
  final String title;
  final String hint;
  final String password;
  final String body;
}

class Contacts {
  static const rowan = Contact(
    id: 'rowan',
    name: 'Rowan Hale',
    subtitle: 'You · Night desk',
    avatar: GameAssets.rowan,
    number: '207-555-0144',
  );

  static const unknown = Contact(
    id: 'unknown',
    name: 'UNKNOWN',
    subtitle: 'No caller ID',
    avatar: GameAssets.moth,
    number: '000-000-0217',
  );

  static const vera = Contact(
    id: 'vera',
    name: 'Vera Quinn',
    subtitle: 'Editor-in-chief',
    avatar: GameAssets.vera,
    number: '207-555-1889',
  );

  static const ellis = Contact(
    id: 'ellis',
    name: 'Ellis Ward',
    subtitle: 'Press operator',
    avatar: GameAssets.ellis,
    number: '207-555-1999',
  );

  static const camille = Contact(
    id: 'camille',
    name: 'Camille Ortiz',
    subtitle: 'Crime desk',
    avatar: GameAssets.camille,
    number: '207-555-0404',
  );

  static const harlan = Contact(
    id: 'harlan',
    name: 'Harlan Crowe',
    subtitle: 'Mayor',
    avatar: GameAssets.harlan,
    number: '207-555-0100',
  );

  static const sable = Contact(
    id: 'sable',
    name: 'Sable',
    subtitle: 'Intern?',
    avatar: GameAssets.sable,
    number: '—',
  );

  static const calder = Contact(
    id: 'calder',
    name: 'Ruth Calder',
    subtitle: 'Night compositor, retired',
    avatar: GameAssets.archives,
    number: '207-555-1102',
  );

  static const masthead = Contact(
    id: 'masthead',
    name: 'The Masthead',
    subtitle: 'Ellis, Camille, Harlan, Vera',
    avatar: GameAssets.newsroom,
    group: true,
  );

  static const feed = Contact(
    id: 'feed',
    name: 'Pier Feed',
    subtitle: 'Marrow Bay',
    avatar: GameAssets.harbor,
  );

  static const all = [unknown, vera, ellis, camille, harlan, sable, calder, masthead, feed];

  static Contact byId(String id) =>
      all.cast<Contact?>().firstWhere((c) => c!.id == id, orElse: () => rowan)!;
}

class EpisodeCopy {
  static const title = 'The Desk';
  static const series = 'Mysterious';
  static const tagline = 'The paper prints the death. Then the death happens.';
  static const pin = '0217';
  static const calderNumber = '2075551102';
  static const ellisNumber = '2075551999';
  static const harlanNumber = '2075550100';
  static const earlyUrl = 'ledger.early';
  static const calderUrl = 'job1102.ledger';
  static const room9Url = 'room9.ledger';
  static const charterUrl = 'charter.ledger';
  static const killUrl = 'ledger.kill';
  static const spikeUrl = 'ledger.spike';
  static const croweUrl = 'crowe.obit';
  static const diaryPassword = 'JUNE';
  static const caslonPassword = 'CASLON';
  static const ninthPassword = 'NINTH';

  static const fragments = [
    'The P.O. box has been closed since',
    '1999. I answered anyway.',
    'Vera thinks she filed me.',
    'Room 9 is not a room.',
  ];

  static const board = [
    BoardCard(id: 'b1', text: 'Vera\'s watch stopped at 2:17, not 6:02.', pair: 'p1'),
    BoardCard(id: 'b2', text: 'Her phone PIN is the minute the press started.', pair: 'p1'),
    BoardCard(id: 'b3', text: 'Lead type in the tray spelled HALE.', pair: 'p2'),
    BoardCard(id: 'b4', text: 'Ellis heard the press print Rowan\'s name first.', pair: 'p2'),
    BoardCard(id: 'b5', text: 'A 1999 drowning was spiked as weather.', pair: 'p3'),
    BoardCard(id: 'b6', text: 'The razored twin on the pier is named June.', pair: 'p3'),
  ];

  static const diary = DiaryPage(
    id: 'd1',
    title: 'Vera Quinn · private',
    hint: 'The name I killed. Four letters. The one that is not on any masthead.',
    password: diaryPassword,
    body:
        'If anyone is reading this I am already ink.\n\nJune went into the harbor on 11/02/99. Harlan paid for a storm. I wrote the storm. The press kept the girl. It has been printing her back, piece by piece, as Sable.\n\nRoom 9 is the page we never bound. I left the key on the hook because I thought filing a person was the same as burying her.\n\nHale: you were not hired to digitize the archive. You were hired because the early edition already had your name in 8-point. I wanted to see if we could unprint a person.\n\nWe cannot.\n\nKill the story. Not the person. I failed both.',
  );
}
