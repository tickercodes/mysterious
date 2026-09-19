import 'package:flutter/foundation.dart';

import '../data/assets.dart';
import '../data/models.dart';
import '../data/story.dart';

enum PhoneId { rowan, vera }

enum AppId {
  home,
  messages,
  chat,
  gallery,
  notes,
  phone,
  recents,
  voicemail,
  call,
  browser,
  files,
  board,
  editions,
  feed,
}

class GameController extends ChangeNotifier {
  GameController({this.instant = false});

  final bool instant;

  PhoneId phone = PhoneId.rowan;
  AppId app = AppId.home;
  String? openChatId;
  String clock = '2:17 AM';
  String task = 'Read the unknown message';
  String? highlightApp;
  int episode = 1;
  int hintsUsedOnTask = 0;
  String? lastHint;
  String? ending;
  bool campaignComplete = false;

  final flags = <String>{};
  final delivered = <String>{};
  final chats = <String, List<ChatLine>>{};
  final unread = <String>{};
  final recents = <String>[];
  List<ReplyChoice>? choices;
  String? choiceChatId;
  bool typing = false;
  bool busy = false;
  bool episodeComplete = false;

  String pinBuffer = '';
  String pinError = '';
  String urlInput = '';
  String? browserPage;
  String diaryInput = '';
  bool diaryOpen = false;
  List<int> fragmentTap = [];
  String? filesError;
  String? boardSelected;
  final matchedPairs = <String>{};
  String? boardError;
  bool voicemailPlaying = false;
  bool inCall = false;
  String? callScript;

  int _line = 0;

  bool get veraUnlocked => flags.contains('veraUnlocked');
  bool get onVera => phone == PhoneId.vera;
  bool get feedHasNew => flags.contains('feedNew');
  String get wallpaper => onVera ? GameAssets.wallpaperVera : GameAssets.wallpaperRowan;
  String get ownerName => onVera ? 'Vera Quinn' : 'Rowan Hale';
  String get phase => _phase();
  List<BoardCard> get currentBoard => Story.boardFor(episode);
  FilePuzzle get currentFiles => Story.filesFor(episode);
  DiaryPage get currentDiary => Story.diaryFor(episode);
  int get boardPairTarget => 3;

  List<ChatLine> thread(String id) => chats[id] ?? const [];

  List<SocialPost> visibleFeed() =>
      Story.feed.where((p) => flags.contains(p.needFlag)).toList();

  List<VoicemailMsg> visibleVoicemail() =>
      Story.voicemails.where((v) => flags.contains(v.needFlag)).toList();

  List<DiaryPage> unlockedDiaries() {
    final pages = <DiaryPage>[];
    if (flags.contains('diaryOpen')) pages.add(Story.diary1);
    if (flags.contains('diary2')) pages.add(Story.diary2);
    if (flags.contains('diary3')) pages.add(Story.diary3);
    if (flags.contains('diary4') || flags.contains('alloyMelted')) pages.add(Story.diary4);
    return pages;
  }

  bool chatVisible(String id) {
    if (id == 'unknown' || id == 'vera' || id == 'ellis' || id == 'camille') {
      return phone == PhoneId.rowan;
    }
    if (id == 'calder') return phone == PhoneId.rowan && flags.contains('recoveredCalder');
    if (id == 'camille_v') return phone == PhoneId.vera && flags.contains('boardDone');
    if (id == 'masthead') return phone == PhoneId.vera;
    if (id == 'sable') {
      return phone == PhoneId.vera && (flags.contains('recoveredSable') || flags.contains('boundRoom9'));
    }
    if (id == 'harlan') {
      return phone == PhoneId.rowan && (flags.contains('calledEllis') || episode >= 2);
    }
    return true;
  }

  List<({Contact contact, String chatId})> inbox() {
    final rows = <({Contact contact, String chatId})>[];
    if (phone == PhoneId.rowan) {
      rows.addAll([
        (contact: Contacts.unknown, chatId: 'unknown'),
        (contact: Contacts.vera, chatId: 'vera'),
        (contact: Contacts.ellis, chatId: 'ellis'),
        (contact: Contacts.camille, chatId: 'camille'),
      ]);
      if (flags.contains('calledEllis') || episode >= 2) {
        rows.add((contact: Contacts.harlan, chatId: 'harlan'));
      }
      if (flags.contains('recoveredCalder')) {
        rows.add((contact: Contacts.calder, chatId: 'calder'));
      }
    } else {
      rows.add((contact: Contacts.masthead, chatId: 'masthead'));
      if (flags.contains('boardDone')) {
        rows.add((contact: Contacts.camille, chatId: 'camille_v'));
      }
      if (flags.contains('recoveredSable') || flags.contains('boundRoom9')) {
        rows.add((contact: Contacts.sable, chatId: 'sable'));
      }
    }
    return rows;
  }

  void start() {
    if (flags.contains('started')) {
      app = AppId.home;
      notifyListeners();
      return;
    }
    flags.add('started');
    highlightApp = 'messages';
    _setTask('Read the unknown message', 'messages');
    _dropUnknownOpening();
    notifyListeners();
  }

  void goHome() {
    app = AppId.home;
    openChatId = null;
    inCall = false;
    notifyListeners();
  }

  void openApp(AppId next) {
    if (next == AppId.home) {
      goHome();
      return;
    }
    if (phone == PhoneId.vera && !veraUnlocked && next != AppId.home) {
      app = AppId.home;
      notifyListeners();
      return;
    }
    app = next;
    if (next == AppId.messages && !flags.contains('openedUnknown')) {
      flags.add('openedUnknown');
      _continueAfterUnknownOpened();
    }
    if (next == AppId.messages && choiceChatId != null) {
      openChat(choiceChatId!);
      return;
    }
    if (next == AppId.voicemail && flags.contains('recoveredSable')) {
      flags.add('listenedVoicemail');
      voicemailPlaying = true;
      if (episode == 1 && !flags.contains('calledEllis')) {
        _setTask('Call Ellis Ward — 207-555-1999', 'phone');
        _dropAfterVoicemail();
      }
    }
    if (next == AppId.voicemail && flags.contains('recoveredCalder') && episode == 2) {
      flags.add('listenedCalderVM');
      if (!flags.contains('calledCalder')) {
        _setTask('Call Ruth Calder — 207-555-1102', 'phone');
      }
    }
    if (next == AppId.feed) {
      flags.remove('feedNew');
    }
    notifyListeners();
  }

  void openChat(String id) {
    app = AppId.chat;
    openChatId = id;
    unread.remove(id);
    if (id == 'masthead') {
      flags.add('readMasthead');
      if (!flags.contains('mastheadFollowup')) {
        flags.add('mastheadFollowup');
        _setTask('Recover the deleted intern thread in Files', 'files');
      }
    }
    if (id == 'unknown' && flags.contains('episode1done') && !flags.contains('readCalderObit') && episode >= 2) {
      flags.add('readCalderObit');
      _setTask('Recover Calder\'s composing file on Vera\'s phone', 'switch');
    }
    if (id == 'vera' && flags.contains('repliedUnknown') && !flags.contains('warnedVera')) {
      choices = const [
        ReplyChoice(
          id: 'v1',
          label: 'I\'m coming up. The edition has your obituary.',
          playerText: 'I\'m coming up. The press printed your obituary for 6:02. This is not a joke.',
          flag: 'warnedVera',
        ),
        ReplyChoice(
          id: 'v2',
          label: 'Who else has a key to the press?',
          playerText: 'Who else has a key to the press tonight.',
          flag: 'warnedVera',
        ),
      ];
      choiceChatId = 'vera';
    }
    if (id == 'camille_v' && flags.contains('boardDone') && !flags.contains('ghostReplied')) {
      choices = const [
        ReplyChoice(
          id: 'g1',
          label: 'Do not sit in my chair.',
          playerText: 'Do not sit in my chair, Camille.',
          flag: 'ghostReplied',
        ),
        ReplyChoice(
          id: 'g2',
          label: 'Spike Harlan. Print the pier.',
          playerText: 'Spike Harlan. Print the pier. Use the name.',
          flag: 'ghostReplied',
        ),
      ];
      choiceChatId = 'camille_v';
    }
    if (id == 'camille' && episode == 2 && flags.contains('calledCalder') && !flags.contains('camilleEp2')) {
      choices = const [
        ReplyChoice(
          id: 'c21',
          label: 'Calder is in the tray. Help me print the pier.',
          playerText: 'Calder is in the tray. Help me print the pier. Use June\'s name.',
          flag: 'leakedToCamille',
        ),
        ReplyChoice(
          id: 'c22',
          label: 'Spike it. I need you alive.',
          playerText: 'Spike it. Weather only. I need you alive more than I need the truth on page one.',
          flag: 'spikedForHarlan',
        ),
      ];
      choiceChatId = 'camille';
    }
    if (id == 'harlan' && episode == 3 && flags.contains('boundRoom9') && !flags.contains('harlanEp3')) {
      choices = const [
        ReplyChoice(
          id: 'h31',
          label: 'Your charter ate a child.',
          playerText: 'Your charter ate a child and called her tide. I have the plate.',
          flag: 'accusedHarlan',
        ),
        ReplyChoice(
          id: 'h32',
          label: 'Put your name in the tray instead.',
          playerText: 'Put your name in the tray instead. The harbor can have a Crowe.',
          flag: 'offeredCrowe',
        ),
        ReplyChoice(
          id: 'h33',
          label: 'I\'m melting the desk.',
          playerText: 'I\'m melting the desk. Sleep somewhere that isn\'t a masthead.',
          flag: 'threatenedKill',
        ),
      ];
      choiceChatId = 'harlan';
    }
    if (id == 'sable' && episode == 3 && flags.contains('boundRoom9') && !flags.contains('sableAsked')) {
      choices = const [
        ReplyChoice(
          id: 's31',
          label: 'I will bind you a yesterday.',
          playerText: 'I will bind you a yesterday. I don\'t know if it will be yours.',
          flag: 'promisedBind',
        ),
        ReplyChoice(
          id: 's32',
          label: 'I\'m sorry I held the rope.',
          playerText: 'I was eight. I held the rope. I thought it was a drowning.',
          flag: 'apologizedJune',
        ),
      ];
      choiceChatId = 'sable';
    }
    notifyListeners();
  }

  void switchPhone() {
    if (phone == PhoneId.rowan) {
      phone = PhoneId.vera;
      pinBuffer = '';
      pinError = '';
    } else {
      phone = PhoneId.rowan;
    }
    app = AppId.home;
    openChatId = null;
    notifyListeners();
  }

  void typePin(String d) {
    if (!flags.contains('veraDead')) {
      pinError = 'Her phone is still in her pocket. Wait.';
      notifyListeners();
      return;
    }
    if (pinBuffer.length >= 4) return;
    pinBuffer += d;
    pinError = '';
    if (pinBuffer.length == 4) {
      if (pinBuffer == EpisodeCopy.pin) {
        flags.add('veraUnlocked');
        clock = '6:11 AM';
        _setTask('Read The Masthead group chat on Vera\'s phone', 'messages');
        _dropVeraUnlock();
      } else {
        pinError = pinBuffer == '0602'
            ? 'Too late. The press does not use time of death.'
            : 'Rejected. The watch did not stop at the end.';
        pinBuffer = '';
      }
    }
    notifyListeners();
  }

  void pinDelete() {
    if (pinBuffer.isEmpty) return;
    pinBuffer = pinBuffer.substring(0, pinBuffer.length - 1);
    notifyListeners();
  }

  void choose(ReplyChoice choice) {
    final chatId = choiceChatId;
    if (chatId == null) return;
    final asSelf = phone == PhoneId.vera ? 'vera' : 'rowan';
    _add(chatId, asSelf, choice.playerText);
    choices = null;
    choiceChatId = null;
    if (choice.flag != null) flags.add(choice.flag!);
    if (choice.id.startsWith('u')) {
      _afterChoice(choice.id);
    } else if (choice.id.startsWith('v')) {
      _veraReplies();
    } else if (choice.id.startsWith('g')) {
      _dropCamillePanic();
    } else if (choice.id.startsWith('c2')) {
      _afterCamilleEp2();
    } else if (choice.id.startsWith('h3')) {
      _afterHarlanEp3();
    } else if (choice.id.startsWith('s3')) {
      _afterSableEp3();
    }
    notifyListeners();
  }

  void recoverTap(int index) {
    final puzzle = currentFiles;
    final doneFlag = switch (episode) {
      2 => 'recoveredCalder',
      3 => 'boundRoom9',
      4 => 'alloyMelted',
      _ => 'recoveredSable',
    };
    if (flags.contains(doneFlag)) return;
    if (!flags.contains(puzzle.needFlag)) {
      filesError = switch (episode) {
        2 => 'Read UNKNOWN\'s new obituary first. Calder is still a rumor.',
        3 => 'Room 9 has to exist in the browser before you can bind it.',
        4 => 'Finish the last case board. The URLs have to mean something.',
        _ => 'Read The Masthead first. The intern was erased from the group.',
      };
      notifyListeners();
      return;
    }
    if (fragmentTap.contains(index)) return;
    final expected = puzzle.order[fragmentTap.length];
    if (index != expected) {
      fragmentTap = [];
      filesError = puzzle.fail;
      notifyListeners();
      return;
    }
    filesError = null;
    fragmentTap.add(index);
    if (fragmentTap.length == puzzle.order.length) {
      flags.add(doneFlag);
      switch (episode) {
        case 2:
          _setTask('Listen to Calder\'s voicemail, then call her', 'phone');
          _dropCalderRecovered();
        case 3:
          _setTask('Sable is on Vera\'s Messages. Then read Harlan.', 'messages');
          _dropRoomBound();
        case 4:
          flags.add('diary4');
          diaryOpen = true;
          _setTask('Type one URL: ledger.spike, crowe.obit, or ledger.kill', 'browser');
          _dropAlloyMelted();
        default:
          _setTask('Listen to Ellis\'s voicemail on Phone', 'phone');
          _dropSableThread();
      }
    }
    notifyListeners();
  }

  void submitUrl() {
    final raw = urlInput.trim().toLowerCase().replaceAll('https://', '').replaceAll('http://', '').replaceAll('www.', '');
    if (raw == EpisodeCopy.earlyUrl || raw == 'ledger.early') {
      browserPage = 'early';
      flags.add('visitedEarly');
      if (episode == 1) _setTask('Open Vera\'s Notes. Password is the razored name.', 'notes');
    } else if (raw == EpisodeCopy.calderUrl || raw == 'job1102.ledger' || raw == 'job1102') {
      browserPage = 'calder';
      flags.add('visitedCalder');
      if (episode == 2) _setTask('Vera\'s Notes. The typeface, not a person.', 'notes');
    } else if (raw == EpisodeCopy.room9Url || raw == 'room9') {
      browserPage = 'room9';
      if (episode >= 3) {
        flags.add('visitedRoom9');
        if (!flags.contains('boundRoom9')) {
          _setTask('Bind Room 9 in Files. Room, hook, yesterday, spike.', 'files');
        }
      }
    } else if (raw == EpisodeCopy.charterUrl || raw == 'charter') {
      browserPage = 'charter';
      flags.add('visitedCharter');
      if (episode == 3) _setTask('Notes password is the forgotten window. Then Case.', 'notes');
    } else if (raw == EpisodeCopy.killUrl || raw == 'kill.ledger') {
      _tryEnding('kill', 'kill');
    } else if (raw == EpisodeCopy.spikeUrl) {
      _tryEnding('spike', 'spike');
    } else if (raw == EpisodeCopy.croweUrl) {
      _tryEnding('crowe', 'crowe');
    } else if (raw.isEmpty) {
      browserPage = null;
    } else {
      browserPage = '404';
    }
    notifyListeners();
  }

  void submitDiary() {
    if (episode == 4) {
      diaryOpen = true;
      flags.add('diary4');
      notifyListeners();
      return;
    }
    final expected = currentDiary.password;
    if (diaryInput.trim().toUpperCase() == expected) {
      diaryOpen = true;
      if (episode == 1) {
        flags.add('diaryOpen');
        _setTask('Connect the proofs on the Case board', 'board');
      } else if (episode == 2) {
        flags.add('diary2');
        flags.add('feedNew');
        _setTask('Connect the new proofs on Case', 'board');
      } else if (episode == 3) {
        flags.add('diary3');
        _setTask('Connect Room 9, June, and the rope on Case', 'board');
      }
    }
    notifyListeners();
  }

  void tapBoard(String id) {
    final lock = switch (episode) {
      2 => 'diary2',
      3 => 'diary3',
      4 => 'episode3done',
      _ => 'diaryOpen',
    };
    if (!flags.contains(lock)) {
      boardError = switch (episode) {
        2 => 'The font closet is still locked. Caslon first.',
        3 => 'Sable\'s intern copy is still sealed. NINTH.',
        4 => 'Finish Room 9 before you set a last line.',
        _ => 'Vera\'s notebook still has the last name. Unlock Notes first.',
      };
      notifyListeners();
      return;
    }
    final card = currentBoard.firstWhere((c) => c.id == id);
    if (matchedPairs.contains(card.pair)) return;
    if (boardSelected == null) {
      boardSelected = id;
      boardError = null;
    } else if (boardSelected == id) {
      boardSelected = null;
    } else {
      final other = currentBoard.firstWhere((c) => c.id == boardSelected);
      if (other.pair == card.pair) {
        matchedPairs.add(card.pair);
        boardSelected = null;
        boardError = null;
        if (matchedPairs.length == boardPairTarget) {
          switch (episode) {
            case 2:
              flags.add('board2');
              _collectCalder();
            case 3:
              flags.add('board3');
              _beginEdition4();
            case 4:
              flags.add('board4ready');
              _setTask('Melt the alloy in Files: 1894, 1999, 2:17, 6:02', 'files');
            default:
              flags.add('boardDone');
              _setTask('Camille just texted Vera\'s phone. Answer her.', 'messages');
              _dropCamilleGhost();
          }
        }
      } else {
        boardError = 'Those proofs do not lock. Try another pairing.';
        boardSelected = null;
      }
    }
    notifyListeners();
  }

  void dial(String number) {
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    recents.insert(0, digits);
    if (digits == EpisodeCopy.ellisNumber || digits == '5551999') {
      inCall = true;
      app = AppId.call;
      callScript = 'ellis';
      flags.add('calledEllis');
      if (episode == 1) _setTask('Open Browser. Type ledger.early', 'browser');
      _dropAfterEllisCall();
    } else if (digits == EpisodeCopy.calderNumber || digits == '5551102') {
      inCall = true;
      app = AppId.call;
      callScript = 'calder';
      flags.add('calledCalder');
      _dropAfterCalderCall();
    } else if (digits == EpisodeCopy.harlanNumber || digits == '5550100') {
      inCall = true;
      app = AppId.call;
      callScript = 'harlan';
      flags.add('calledHarlan');
      if (episode >= 3 && !flags.contains('visitedCharter')) {
        _setTask('Type charter.ledger — then Notes.', 'browser');
      }
    } else if (digits == '0000000217' || digits == '0217') {
      inCall = true;
      app = AppId.call;
      callScript = 'unknown';
    } else {
      inCall = true;
      app = AppId.call;
      callScript = 'dead';
    }
    notifyListeners();
  }

  void hangUp() {
    inCall = false;
    app = AppId.phone;
    notifyListeners();
  }

  void ghostReply(String text) {
    if (flags.contains('ghostReplied')) return;
    _add('camille_v', 'vera', text);
    flags.add('ghostReplied');
    _dropCamillePanic();
    notifyListeners();
  }

  void useHint() {
    final pack = Story.hintsFor(phase);
    if (hintsUsedOnTask >= 3) {
      lastHint = 'No more hints on this task. Re-read Photos.';
    } else {
      lastHint = pack[hintsUsedOnTask.clamp(0, pack.length - 1)];
      hintsUsedOnTask++;
    }
    notifyListeners();
  }

  void _tryEnding(String page, String which) {
    if (episode < 4 || !flags.contains('board4ready')) {
      browserPage = 'tooearly';
      return;
    }
    if (which == 'kill' && !flags.contains('alloyMelted')) {
      browserPage = 'killlocked';
      return;
    }
    browserPage = page;
    if (campaignComplete) return;
    ending = which;
    campaignComplete = true;
    flags.add('campaignComplete');
    flags.add('feedNew');
    clock = '6:02 AM';
    _setTask('Edition closed. The last line is set.', 'editions');
    _dropEnding(which);
  }

  void _setTask(String next, String? hi) {
    if (task != next) {
      hintsUsedOnTask = 0;
      lastHint = null;
    }
    task = next;
    highlightApp = hi;
  }

  void _resetPuzzleState() {
    fragmentTap = [];
    filesError = null;
    boardSelected = null;
    matchedPairs.clear();
    diaryOpen = false;
    diaryInput = '';
    urlInput = '';
    browserPage = null;
    lastHint = null;
    hintsUsedOnTask = 0;
  }

  String _phase() {
    if (campaignComplete) return 'e4_end';
    if (episode == 4) {
      if (!flags.contains('alloyMelted')) return 'e4_melt';
      return 'e4_end';
    }
    if (episode == 3) {
      if (!flags.contains('visitedRoom9')) return 'e3_room';
      if (!flags.contains('boundRoom9')) return 'e3_files';
      if (!flags.contains('diary3')) return 'e3_charter';
      return 'e3_board';
    }
    if (episode == 2) {
      if (!flags.contains('readCalderObit')) return 'e2_obit';
      if (!flags.contains('recoveredCalder')) return 'e2_files';
      if (!flags.contains('calledCalder')) return 'e2_call';
      if (!flags.contains('visitedCalder')) return 'e2_url';
      if (!flags.contains('diary2')) return 'e2_notes';
      return 'e2_board';
    }
    if (!flags.contains('repliedUnknown')) return 'e1_unknown';
    if (!flags.contains('veraDead')) return 'e1_vera';
    if (!veraUnlocked) return 'e1_pin';
    if (!flags.contains('readMasthead')) return 'e1_masthead';
    if (!flags.contains('recoveredSable')) return 'e1_files';
    if (!flags.contains('calledEllis')) return 'e1_call';
    if (!flags.contains('visitedEarly')) return 'e1_url';
    if (!flags.contains('diaryOpen')) return 'e1_notes';
    if (!flags.contains('boardDone')) return 'e1_board';
    return 'e1_ghost';
  }

  void _afterChoice(String id) {
    if (id.startsWith('u')) {
      flags.add('repliedUnknown');
      _setTask('Warn Vera Quinn in Messages', 'messages');
      _add('unknown', 'unknown', 'Go upstairs. Show her. If she laughs, remember the sound. You will need it later.');
      unread.add('unknown');
    }
  }

  void _dropUnknownOpening() {
    _add('unknown', 'unknown', 'Rowan Hale.');
    _add('unknown', 'unknown', 'Don\'t go back to sleep.');
    _add(
      'unknown',
      'unknown',
      'The Ledger already wrote her ending. You have until 6:02.',
      image: GameAssets.obituary,
    );
    unread.add('unknown');
  }

  void _continueAfterUnknownOpened() {
    if (delivered.contains('unknownAsk')) return;
    delivered.add('unknownAsk');
    choices = const [
      ReplyChoice(
        id: 'u1',
        label: 'Who is this?',
        playerText: 'Who is this.',
        flag: 'askedWho',
      ),
      ReplyChoice(
        id: 'u2',
        label: 'Vera is upstairs. Alive.',
        playerText: 'Vera is upstairs. I can hear her. This is a sick joke.',
        flag: 'calledJoke',
      ),
      ReplyChoice(
        id: 'u3',
        label: 'How do you have the edition?',
        playerText: 'That proof is still wet. How do you have it.',
        flag: 'askedHow',
      ),
    ];
    choiceChatId = 'unknown';
  }

  void _veraReplies() {
    _add('vera', 'vera', 'Hale. It is 2:19. If the press wants me dead it will have to get in line.');
    _add('vera', 'vera', 'Go home. That\'s an order.');
    clock = '6:02 AM';
    _add('vera', 'vera', 'ellis was here. the tray—', image: GameAssets.printRoom);
    _add('vera', 'system', 'Message unsent.', system: true);
    _add('unknown', 'unknown', '6:02. On time.');
    _add('unknown', 'unknown', 'Her body is in the ink. Her phone is not. Lost & Found, press room.');
    _add(
      'unknown',
      'unknown',
      'PIN = the minute the watch stopped. Not the minute she died. The early edition never uses time of death.',
      image: GameAssets.evidenceTable,
    );
    unread.add('unknown');
    _setTask('Switch to Vera\'s phone. Unlock it.', 'switch');
    flags.add('veraDead');
    flags.add('feedNew');
  }

  void _dropVeraUnlock() {
    _add('masthead', 'system', 'You joined The Masthead as Vera Quinn.', system: true);
    _add('masthead', 'camille', 'She wants to print the pier. Tonight. The 1999 drowning. With a name.');
    _add('masthead', 'harlan', 'Spike it or I pull every inch of advertising. Marrow Bay does tides, not tragedies.');
    _add('masthead', 'ellis', 'The alloy still remembers 1999. We melted the story. We did not kill it.');
    _add('masthead', 'vera', 'Kill the story, not the person. I have said this for twenty-five years.');
    _add('masthead', 'camille', 'Then why is there an intern on the roster who does not have a yesterday?');
    _add('masthead', 'system', 'Sable was added, then removed.', system: true);
    _add('masthead', 'ellis', 'She is in room 9.');
    unread.add('masthead');
  }

  void _dropSableThread() {
    _add('sable', 'sable', 'The P.O. box has been closed since 1999. I answered anyway.');
    _add('sable', 'vera', 'Who gave you a keycard dated yesterday?');
    _add('sable', 'sable', 'Vera thinks she filed me. Room 9 is not a room. It is a page you never bound.');
    _add('sable', 'sable', 'When the press runs the early edition it is not predicting. It is collecting.');
    unread.add('sable');
  }

  void _dropAfterVoicemail() {
    if (delivered.contains('vm')) return;
    delivered.add('vm');
    _add(
      'ellis',
      'ellis',
      'If you heard the voicemail, you heard the name. It printed HALE before it printed QUINN. I clocked out. I came back. I am not a killer. I am a witness the paper will not hire.',
    );
    unread.add('ellis');
  }

  void _dropAfterEllisCall() {
    if (delivered.contains('ellisCall')) return;
    delivered.add('ellisCall');
    _add(
      'ellis',
      'ellis',
      'The site is ledger.early — not the public one. Vera hid the archive in a subdomain the town is not supposed to type.',
    );
    unread.add('ellis');
  }

  void _dropCamilleGhost() {
    _add('camille_v', 'camille', 'Vera. I\'m in your chair. Don\'t be mad. Someone has to put the paper to bed.');
    _add('camille_v', 'camille', 'The intern is gone. Harlan wants a weather story. Tell me what to spike.');
    unread.add('camille_v');
  }

  void _dropCamillePanic() {
    if (delivered.contains('ghost')) return;
    delivered.add('ghost');
    _add('camille_v', 'camille', 'This isn\'t funny.');
    _add('camille_v', 'camille', 'They pulled you out of the tray.');
    _add('camille_v', 'camille', 'Who is this.');
    unread.add('camille_v');
    episodeComplete = true;
    flags.add('episode1done');
    _beginEdition2();
  }

  void _beginEdition2() {
    episode = 2;
    _resetPuzzleState();
    phone = PhoneId.rowan;
    app = AppId.home;
    openChatId = null;
    clock = '2:17 AM';
    flags.add('feedNew');
    _add('unknown', 'unknown', 'Edition Two is already in the tray.');
    _add(
      'unknown',
      'unknown',
      'Ruth Calder. 6:02. She set a girl into type in 1999 and called it a correction.\n\nYour obituary is still set. The last line is blank. For a name you have not learned yet.',
      image: GameAssets.obituary,
    );
    _add('camille', 'camille', 'Rowan. I know that wasn\'t Vera. I\'m still in her chair. Tell me what I\'m allowed to print.');
    _add('harlan', 'harlan', 'You will print weather. You will not print compositors. Do not call the old composing room.');
    unread.addAll({'unknown', 'camille', 'harlan'});
    _setTask('Read UNKNOWN. Ruth Calder is in the tray.', 'messages');
  }

  void _dropCalderRecovered() {
    _add(
      'calder',
      'calder',
      'If this recovered, the font closet is open. I keep a box that pretends to be a job ticket. 1102. I will pick up. I already know I should not.',
    );
    unread.add('calder');
  }

  void _dropAfterCalderCall() {
    if (delivered.contains('calderCall')) return;
    delivered.add('calderCall');
    _add(
      'calder',
      'calder',
      'The proof slip is job1102.ledger. It will not save me. Type it anyway. Caslon is the password Vera left when she razored a living proof. Ticket. Typeface. Window. In that hunger.',
    );
    _add('ellis', 'ellis', 'She told you. She will still sit down at 6:02. The charter does not take warnings. I pulled the breaker. It started itself.');
    unread.addAll({'calder', 'ellis'});
    _setTask('Browser: type job1102.ledger', 'browser');
  }

  void _afterCamilleEp2() {
    flags.add('camilleEp2');
    if (flags.contains('leakedToCamille')) {
      _add('camille', 'camille', 'Then I\'m printing the pier. If they fire me I will still have a yesterday.');
    } else {
      _add('camille', 'camille', 'Weather. Fine. I will hate you in the morning, if mornings still happen.');
    }
    unread.add('camille');
  }

  void _collectCalder() {
    clock = '6:02 AM';
    flags.add('episode2done');
    flags.add('feedNew');
    _add('unknown', 'unknown', '6:02. On time. Calder is in the tray. She died in Caslon, which is a joke she would have set in 8-point.');
    _add('unknown', 'unknown', 'Room 9 is a URL now. room9.ledger — then bind the page or she stays intern-shaped forever.');
    _add('sable', 'sable', 'The hook is waiting. I would like a yesterday.');
    unread.addAll({'unknown', 'sable'});
    _beginEdition3();
  }

  void _beginEdition3() {
    episode = 3;
    _resetPuzzleState();
    clock = '2:17 AM';
    _setTask('Browser: type room9.ledger. Then bind the page in Files.', 'browser');
  }

  void _dropRoomBound() {
    flags.add('feedNew');
    _add('sable', 'system', 'Room 9 bound. Intern copy unsealed.', system: true);
    _add('sable', 'sable', 'I was June Quinn. They paid the tide. The tide took a story. I stayed.');
    _add('sable', 'sable', 'You held the rope. You were eight. Vera hired you so the tray would not have to learn a new mouth.');
    _add('harlan', 'harlan', 'Hale. You bound a problem. The charter is charter.ledger. Read it. Then tell me which name you are willing to feed.');
    unread.addAll({'sable', 'harlan'});
  }

  void _afterHarlanEp3() {
    flags.add('harlanEp3');
    _add(
      'harlan',
      'harlan',
      'My grandfather bound water with a desk. You think you are a journalist. You are a compositor with a conscience. Conscience does not keep harbors still.',
    );
    unread.add('harlan');
  }

  void _afterSableEp3() {
    flags.add('sableAsked');
    _add('sable', 'sable', 'Then look at the board. Match me to the pier. Match you to the rope. After that the tray sets your obituary whether you deserve one or not.');
    unread.add('sable');
    if (!flags.contains('diary3')) {
      _setTask('Notes on Vera\'s phone. Password: NINTH.', 'notes');
    }
  }

  void _beginEdition4() {
    episode = 4;
    flags.add('episode3done');
    flags.add('feedNew');
    _resetPuzzleState();
    clock = '2:17 AM';
    phone = PhoneId.rowan;
    app = AppId.home;
    openChatId = null;
    _add(
      'unknown',
      'unknown',
      'Special edition. Your obituary is in the tray. The last line is blank on purpose.\n\nCase board names three URLs. Files melts the years. Browser prints whichever name you can live with.',
      image: GameAssets.obituary,
    );
    unread.add('unknown');
    _setTask('Open Case. Then melt the alloy. Then type one last URL.', 'board');
  }

  void _dropAlloyMelted() {
    flags.add('feedNew');
    _add('unknown', 'unknown', 'The metal will take a name now. Type it. Do not ask me which. I am the moth. I am the girl. I am the desk. I am tired.');
    unread.add('unknown');
  }

  void _dropEnding(String which) {
    switch (which) {
      case 'spike':
        _add('unknown', 'unknown', 'June is weather again. You still have a job. The charter will eat a tourist in March. Sleep well, Hale. The tray already knows the next mouth.');
        _add('camille', 'camille', 'We printed high tide. I will never forgive the grammar.');
      case 'crowe':
        _add('unknown', 'unknown', 'Harlan Crowe, 6:02. The harbor stays bound. I keep a yesterday. You become the man who fed a mayor to a machine. That is also a kind of byline.');
        _add('sable', 'sable', 'I can be photographed from the left now. Thank you. I will not say it twice.');
      default:
        _add('unknown', 'unknown', 'The desk is slag. The harbor is only water. I am June, from the side, in daylight, with a yesterday that includes a rope and a boy who was eight.\n\nYour last line is not an obituary. It is a resignation. Burn the moth. Go inland.');
        _add('ellis', 'ellis', 'I pulled the breaker. This time it stayed down. I am going to learn a trade that does not eat names.');
    }
    unread.add('unknown');
  }

  void _add(String chatId, String senderId, String text, {String? image, bool system = false}) {
    final list = chats.putIfAbsent(chatId, () => []);
    list.add(ChatLine(
      id: 'l${_line++}',
      chatId: chatId,
      senderId: senderId,
      text: text,
      image: image,
      system: system,
      time: clock,
    ));
  }
}
