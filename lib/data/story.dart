import 'assets.dart';
import 'models.dart';

class EditionInfo {
  const EditionInfo({
    required this.id,
    required this.title,
    required this.blurb,
  });

  final int id;
  final String title;
  final String blurb;
}

class FilePuzzle {
  const FilePuzzle({
    required this.label,
    required this.hint,
    required this.fail,
    required this.needFlag,
    required this.fragments,
    required this.order,
  });

  final String label;
  final String hint;
  final String fail;
  final String needFlag;
  final List<String> fragments;
  final List<int> order;
}

class SocialPost {
  const SocialPost({
    required this.author,
    required this.handle,
    required this.body,
    required this.needFlag,
    this.image,
  });

  final String author;
  final String handle;
  final String body;
  final String needFlag;
  final String? image;
}

class VoicemailMsg {
  const VoicemailMsg({
    required this.from,
    required this.time,
    required this.body,
    required this.needFlag,
  });

  final String from;
  final String time;
  final String body;
  final String needFlag;
}

class Story {
  static const editions = [
    EditionInfo(id: 1, title: 'The Ink Tray', blurb: 'The paper prints Vera. Then Vera happens.'),
    EditionInfo(id: 2, title: 'Job Ticket 1102', blurb: 'Ruth Calder has until 6:02. She set a girl in Caslon and kept the plate.'),
    EditionInfo(id: 3, title: 'The Ninth Window', blurb: 'Room 9 is a page. Sable wants it bound or burned.'),
    EditionInfo(id: 4, title: 'Special Edition', blurb: 'The last line of your obituary is still blank. You have to set it.'),
  ];

  static const board1 = [
    BoardCard(id: 'b1', text: 'Vera\'s watch stopped at 2:17, not 6:02.', pair: 'p1'),
    BoardCard(id: 'b2', text: 'Her phone PIN is the minute the press started.', pair: 'p1'),
    BoardCard(id: 'b3', text: 'Lead type in the tray spelled HALE.', pair: 'p2'),
    BoardCard(id: 'b4', text: 'Ellis heard the press print Rowan\'s name first.', pair: 'p2'),
    BoardCard(id: 'b5', text: 'A 1999 drowning was spiked as weather.', pair: 'p3'),
    BoardCard(id: 'b6', text: 'The razored twin on the pier is named June.', pair: 'p3'),
  ];

  static const board2 = [
    BoardCard(id: 'c1', text: 'Job ticket 1102 is November 2 — the pier date.', pair: 'q1'),
    BoardCard(id: 'c2', text: 'Calder\'s voicemail box uses the drowned girl\'s calendar.', pair: 'q1'),
    BoardCard(id: 'c3', text: 'June was not buried. She was set in Caslon.', pair: 'q2'),
    BoardCard(id: 'c4', text: 'Vera razored a living proof and called it weather.', pair: 'q2'),
    BoardCard(id: 'c5', text: 'The charter needs one obituary on the desk before dawn.', pair: 'q3'),
    BoardCard(id: 'c6', text: 'Harlan\'s family has fed the tray since 1894.', pair: 'q3'),
  ];

  static const board3 = [
    BoardCard(id: 'd1', text: 'Room 9 is an unbound page, not a door.', pair: 'r1'),
    BoardCard(id: 'd2', text: 'The fire map forgot a window because it was never brick.', pair: 'r1'),
    BoardCard(id: 'd3', text: 'Sable has no yesterday. Interns who are corrections don\'t.', pair: 'r2'),
    BoardCard(id: 'd4', text: 'June Quinn is still walking as an uncorrected proof.', pair: 'r2'),
    BoardCard(id: 'd5', text: 'Rowan held the rope on the pier in 1999.', pair: 'r3'),
    BoardCard(id: 'd6', text: 'Vera hired Hale because the tray already knew him.', pair: 'r3'),
  ];

  static const board4 = [
    BoardCard(id: 'e1', text: 'ledger.spike returns June to weather. You keep your job.', pair: 's1'),
    BoardCard(id: 'e2', text: 'Spiking the girl feeds the charter another year of Crowes.', pair: 's1'),
    BoardCard(id: 'e3', text: 'crowe.obit puts Harlan in the tray at 6:02.', pair: 's2'),
    BoardCard(id: 'e4', text: 'A Crowe in the alloy keeps the harbor bound — and Sable walking.', pair: 's2'),
    BoardCard(id: 'e5', text: 'ledger.kill melts 1894, 1999, 2:17, and 6:02 in that order.', pair: 's3'),
    BoardCard(id: 'e6', text: 'If the desk dies, the last line is yours. No reprint. No intern.', pair: 's3'),
  ];

  static const files1 = FilePuzzle(
    label: 'sable_thread.dat  ·  corrupted',
    hint: 'Tap the fragments in the order the intern wrote them. The year comes second.',
    fail: 'The alloy rejects a wrong order. Year comes second.',
    needFlag: 'readMasthead',
    fragments: EpisodeCopy.fragments,
    order: [0, 1, 2, 3],
  );

  static const files2 = FilePuzzle(
    label: 'job1102.dat  ·  composing recover',
    hint: 'Start with the ticket. Then what it really is. Then where she hid the plate.',
    fail: 'The font closet stays shut. Ticket first.',
    needFlag: 'readCalderObit',
    fragments: [
      'Calder kept the plate in the font closet.',
      'Job ticket 1102 is not a ticket.',
      'The composing room never had a ninth window. The press did.',
      'It is the date we set a girl into Caslon.',
    ],
    order: [1, 3, 0, 2],
  );

  static const files3 = FilePuzzle(
    label: 'room9.page  ·  unbound',
    hint: 'Bind the sentence the way a compositor would: room, hook, yesterday, spike.',
    fail: 'Unbound. Start with the room, not the girl.',
    needFlag: 'visitedRoom9',
    fragments: [
      'If you spike me I go back to weather.',
      'Room 9 is the page we never bound.',
      'I still have a yesterday if you print me.',
      'Hook. Key. Ninth window.',
    ],
    order: [1, 3, 2, 0],
  );

  static const files4 = FilePuzzle(
    label: 'alloy_melt.job  ·  the desk',
    hint: 'Chronological. Charter, twin, watch, collection.',
    fail: 'The metal will not melt out of order. 1894 first.',
    needFlag: 'board4ready',
    fragments: [
      '1894 — the harbor is bound to a desk.',
      '1999 — a twin is paid as tide.',
      '2:17 — the watch, the press, the lie.',
      '6:02 — collection.',
    ],
    order: [0, 1, 2, 3],
  );

  static const diary1 = EpisodeCopy.diary;

  static const diary2 = DiaryPage(
    id: 'd2',
    title: 'Vera Quinn · font closet',
    hint: 'The typeface we used on a living girl. Six letters. A foundry, not a person.',
    password: EpisodeCopy.caslonPassword,
    body:
        'Caslon. I told Calder it was a correction. You cannot drown a proof. You can only razor it.\n\nHarlan paid for weather. I wrote weather. The press kept June anyway and issued her a keycard dated tomorrow.\n\nHale: if you are in my notes, Calder is already in the tray. She will tell you the job ticket. She will still die. The charter does not take warnings.\n\nRoom 9 is in the archive wall the fire map skipped. A window that is a page. Bind her or bury her. I did neither.',
  );

  static const diary3 = DiaryPage(
    id: 'd3',
    title: 'Sable · intern copy',
    hint: 'The window the fire forgot. Five letters. Not a number.',
    password: EpisodeCopy.ninthPassword,
    body:
        'My name was June Quinn. They paid the tide to take me. The tide took a story. I stayed in the alloy.\n\nRowan held the rope. He was eight. He still thinks he failed a drowning. He failed a typesetting.\n\nVera hired him so the tray would not have to learn a new mouth.\n\nIf you bind Room 9 I get a yesterday. If you spike me I become weather again. If you melt the desk I become a woman who can be photographed from the side.\n\nHarlan will offer you the Crowe ending. It is the only ending that lets him sleep.',
  );

  static const diary4 = DiaryPage(
    id: 'd4',
    title: 'Night desk · last line',
    hint: 'Unlocked when the alloy is ready. No password. Only a choice.',
    password: '',
    body:
        'Three URLs. Type one. The browser does not search. The desk does not negotiate.\n\nledger.spike — June returns to weather. You keep the night desk. The charter eats someone else next year.\n\ncrowe.obit — Harlan at 6:02. Sable keeps walking. The harbor stays "bound." You become the man who fed a mayor to a machine.\n\nledger.kill — melt the order in Files first. Then type it. The last line of your obituary fills with whatever you were when you were eight, holding a rope, and it will not print again.',
  );

  static const feed = [
    SocialPost(
      author: 'Marrow Bay PD',
      handle: '@mbpd',
      body: 'No active missing persons. Rumors about the Ledger are not police business. Stop calling the tip line about "early editions."',
      needFlag: 'started',
      image: GameAssets.harbor,
    ),
    SocialPost(
      author: 'Pier Watch',
      handle: '@pierwatch',
      body: '2:17 a.m. and the print-room lights are on again. That building is supposed to be dark until five. I can hear the press from the bait shop.',
      needFlag: 'openedUnknown',
    ),
    SocialPost(
      author: 'Camille Ortiz',
      handle: '@cortizdesk',
      body: 'If anyone still has the 11/02/99 weather plate, I need a scan. Not for a story. For a funeral I have not been allowed to name.',
      needFlag: 'veraDead',
      image: GameAssets.twinsPhoto,
    ),
    SocialPost(
      author: 'Ruth Calder',
      handle: '@rcaldercomp',
      body: 'I will not take freelance tomorrow. The font closet is locked. Do not call the composing room after 2.',
      needFlag: 'readCalderObit',
      image: GameAssets.archives,
    ),
    SocialPost(
      author: 'Harlan Crowe',
      handle: '@mayorcrowe',
      body: 'Marrow Bay does tides, not tragedies. Any "special edition" is a hoax. The harbor is fine. The paper will print fishing reports.',
      needFlag: 'calledCalder',
    ),
    SocialPost(
      author: 'deleted user',
      handle: '@sable',
      body: 'I was added to this town and then removed. If you can see this, Room 9 still has a hook. I would like a yesterday.',
      needFlag: 'diary2',
      image: GameAssets.sable,
    ),
    SocialPost(
      author: 'Ellis Ward',
      handle: '@pressellis',
      body: 'I am not a killer. I am a witness the paper will not hire. If the tray spells your name, do not sit down.',
      needFlag: 'episode2done',
    ),
    SocialPost(
      author: 'Pier Watch',
      handle: '@pierwatch',
      body: 'The ninth window on the archive wall is lit and there is no ninth window. I counted. Twice. The harbor is too loud.',
      needFlag: 'visitedRoom9',
      image: GameAssets.archives,
    ),
    SocialPost(
      author: 'Marrow Bay PD',
      handle: '@mbpd',
      body: 'We do not investigate newspapers. We do not investigate composing rooms. We especially do not investigate mayors. Stop.',
      needFlag: 'episode3done',
    ),
    SocialPost(
      author: 'UNKNOWN',
      handle: '@earlyedition',
      body: 'The last line is still blank. Type carefully. Whatever you set at 6:02 becomes the town.',
      needFlag: 'alloyMelted',
      image: GameAssets.obituary,
    ),
  ];

  static const voicemails = [
    VoicemailMsg(
      from: 'Ellis Ward',
      time: '1:51 AM',
      body:
          '"I came back. Don\'t put that in the paper. The press was already running. It was not printing Quinn. It was printing Hale. I thought it was a misfeed. Then she walked in. Then she sat down. Then the tray... I should have pulled the breaker. I watched it finish the name."',
      needFlag: 'recoveredSable',
    ),
    VoicemailMsg(
      from: 'Ruth Calder',
      time: 'Composing room',
      body:
          '"You have reached Ruth Calder, night compositor, retired. For the 1999 plate, enter the job ticket that is a date. 1-1-0-2. For anyone still breathing, hang up. The living are not our department after 2:17."',
      needFlag: 'recoveredCalder',
    ),
    VoicemailMsg(
      from: 'Harlan Crowe',
      time: '3:40 AM',
      body:
          '"Hale. You will print weather. You will not print twins. My grandfather bound this harbor with a desk and a name. If you unbind it, the water comes for the people who still have yesterdays. Call me when you remember which side pays you."',
      needFlag: 'visitedCharter',
    ),
    VoicemailMsg(
      from: 'Sable',
      time: 'no timestamp',
      body:
          '"I do not leave voicemail. I leave unmarked pages. Bind me. Or melt the thing that keeps reprinting us. Do not let him offer you the Crowe ending like it is mercy."',
      needFlag: 'boundRoom9',
    ),
  ];

  static List<BoardCard> boardFor(int episode) {
    return switch (episode) {
      2 => board2,
      3 => board3,
      4 => board4,
      _ => board1,
    };
  }

  static FilePuzzle filesFor(int episode) {
    return switch (episode) {
      2 => files2,
      3 => files3,
      4 => files4,
      _ => files1,
    };
  }

  static DiaryPage diaryFor(int episode) {
    return switch (episode) {
      2 => diary2,
      3 => diary3,
      4 => diary4,
      _ => diary1,
    };
  }

  static List<String> hintsFor(String phase) {
    return switch (phase) {
      'e1_unknown' => [
          'Open Messages. The moth has already written.',
          'UNKNOWN sent a wet obituary. Read it before you argue.',
          'Your first reply does not save her. It only tells the press you are awake.',
        ],
      'e1_vera' => [
          'Warn Vera from your own phone. She is still upstairs.',
          'She will order you home. Stay long enough to see the last photo.',
          'The watch is the PIN later. Listen for 2:17, not 6:02.',
        ],
      'e1_pin' => [
          'Switch phones. Lost & Found, press room.',
          'PIN is the minute the watch stopped.',
          'Try 0217. 0602 is time of death. The early edition never uses that.',
        ],
      'e1_masthead' => [
          'Read The Masthead on Vera\'s phone.',
          'Someone named Sable was added, then removed.',
          'Files next. The intern is in the corrupted thread.',
        ],
      'e1_files' => [
          'Open Files on Vera\'s phone.',
          'Tap fragments in written order. The year is the second line.',
          'Line 2 starts with 1999.',
        ],
      'e1_call' => [
          'Phone app. Voicemail first.',
          'Ellis left a number in the town\'s oldest habit: 207-555-1999.',
          'Dial him. He will give you a URL, not comfort.',
        ],
      'e1_url' => [
          'Browser. It does not search.',
          'Type ledger.early exactly.',
          'No www. Ellis was specific.',
        ],
      'e1_notes' => [
          'Vera\'s Notes. The razored name.',
          'Four letters. The twin who became weather.',
          'JUNE.',
        ],
      'e1_board' => [
          'Case board. Proofs that lock.',
          'Watch pairs with PIN. Hale pairs with Ellis. Weather pairs with June.',
          'Three pairs. Then Camille will text a dead woman.',
        ],
      'e1_ghost' => [
          'Camille is in Vera\'s chair. Answer as Vera.',
          'Your wording scares her. That is the point.',
          'Open Messages on Vera\'s phone.',
        ],
      'e2_obit' => [
          'UNKNOWN has a new wet page. Ruth Calder.',
          'Read it on Rowan\'s phone.',
          'Then recover the composing-room file on Vera\'s phone.',
        ],
      'e2_files' => [
          'Vera / Files. Ticket first.',
          '1102 is a date pretending to be a job number.',
          'Order: ticket, Caslon, closet, window.',
        ],
      'e2_call' => [
          'Voicemail box in the old composing room.',
          'Dial 207-555-1102.',
          'Calder will talk. She will still be in the tray.',
        ],
      'e2_url' => [
          'Type job1102.ledger',
          'The proof slip confirms the ticket is a date.',
          'Then Notes. The typeface, not a person.',
        ],
      'e2_notes' => [
          'Password is the typeface used on a living girl.',
          'Six letters.',
          'CASLON.',
        ],
      'e2_board' => [
          'New proofs. Match date to voicemail, Caslon to razor, charter to Crowe.',
          'Three pairs again.',
          'Then the press collects Calder whether you warned her or not.',
        ],
      'e3_room' => [
          'Browser: room9.ledger',
          'Sable will write once the page exists.',
          'Bind the file in the compositor\'s order.',
        ],
      'e3_files' => [
          'Room, hook, yesterday, spike.',
          'Do not start with her plea.',
          'Vera\'s Files, still.',
        ],
      'e3_charter' => [
          'Type charter.ledger after Harlan talks.',
          'Then call 207-555-0100 if you want his version.',
          'Notes password: the forgotten window. NINTH.',
        ],
      'e3_board' => [
          'Match room to window, Sable to June, rope to hiring.',
          'This board is about you, Hale.',
          'Three pairs. Then the tray sets your obituary.',
        ],
      'e4_melt' => [
          'Read the last UNKNOWN page.',
          'Case board first — it names the three URLs.',
          'Then Files: 1894, 1999, 2:17, 6:02.',
        ],
      'e4_end' => [
          'Type one URL. Only one will print.',
          'ledger.spike / crowe.obit / ledger.kill',
          'Kill requires the alloy melted. Spike and Crowe do not forgive you either.',
        ],
      _ => [
          'Follow the red TASK bar.',
          'Tap HINT again for a sharper push.',
          'Re-read the last photo in Gallery. The press hides in the grain.',
        ],
    };
  }
}
