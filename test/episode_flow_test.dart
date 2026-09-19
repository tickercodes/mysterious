import 'package:flutter_test/flutter_test.dart';
import 'package:mysterious/data/models.dart';
import 'package:mysterious/data/story.dart';
import 'package:mysterious/state/game_controller.dart';

void main() {
  test('full campaign can be completed through all four editions', () {
    final g = GameController(instant: true);
    g.start();
    expect(g.thread('unknown'), isNotEmpty);

    g.openApp(AppId.messages);
    expect(g.choices, isNotNull);
    g.choose(g.choices!.first);
    expect(g.flags.contains('repliedUnknown'), isTrue);

    g.openChat('vera');
    expect(g.choices, isNotNull);
    g.choose(g.choices!.first);
    expect(g.flags.contains('veraDead'), isTrue);

    g.switchPhone();
    g.typePin('0');
    g.typePin('2');
    g.typePin('1');
    g.typePin('7');
    expect(g.veraUnlocked, isTrue);

    g.openChat('masthead');
    expect(g.flags.contains('readMasthead'), isTrue);

    g.recoverTap(0);
    g.recoverTap(1);
    g.recoverTap(2);
    g.recoverTap(3);
    expect(g.flags.contains('recoveredSable'), isTrue);

    g.openApp(AppId.voicemail);
    g.dial(EpisodeCopy.ellisNumber);
    expect(g.flags.contains('calledEllis'), isTrue);

    g.urlInput = 'ledger.early';
    g.submitUrl();
    expect(g.flags.contains('visitedEarly'), isTrue);

    g.diaryInput = 'JUNE';
    g.submitDiary();
    expect(g.diaryOpen, isTrue);

    g.tapBoard('b1');
    g.tapBoard('b2');
    g.tapBoard('b3');
    g.tapBoard('b4');
    g.tapBoard('b5');
    g.tapBoard('b6');
    expect(g.flags.contains('boardDone'), isTrue);

    g.openChat('camille_v');
    expect(g.choices, isNotNull);
    g.choose(g.choices!.first);
    expect(g.episodeComplete, isTrue);
    expect(g.episode, 2);

    g.openChat('unknown');
    expect(g.flags.contains('readCalderObit'), isTrue);

    g.recoverTap(Story.files2.order[0]);
    g.recoverTap(Story.files2.order[1]);
    g.recoverTap(Story.files2.order[2]);
    g.recoverTap(Story.files2.order[3]);
    expect(g.flags.contains('recoveredCalder'), isTrue);

    g.openApp(AppId.voicemail);
    g.dial(EpisodeCopy.calderNumber);
    expect(g.flags.contains('calledCalder'), isTrue);

    g.urlInput = 'job1102.ledger';
    g.submitUrl();
    expect(g.flags.contains('visitedCalder'), isTrue);

    g.diaryInput = 'CASLON';
    g.submitDiary();
    expect(g.flags.contains('diary2'), isTrue);

    g.tapBoard('c1');
    g.tapBoard('c2');
    g.tapBoard('c3');
    g.tapBoard('c4');
    g.tapBoard('c5');
    g.tapBoard('c6');
    expect(g.episode, 3);

    g.urlInput = 'room9.ledger';
    g.submitUrl();
    expect(g.flags.contains('visitedRoom9'), isTrue);

    g.recoverTap(Story.files3.order[0]);
    g.recoverTap(Story.files3.order[1]);
    g.recoverTap(Story.files3.order[2]);
    g.recoverTap(Story.files3.order[3]);
    expect(g.flags.contains('boundRoom9'), isTrue);

    g.urlInput = 'charter.ledger';
    g.submitUrl();
    expect(g.flags.contains('visitedCharter'), isTrue);

    g.diaryInput = 'NINTH';
    g.submitDiary();
    expect(g.flags.contains('diary3'), isTrue);

    g.tapBoard('d1');
    g.tapBoard('d2');
    g.tapBoard('d3');
    g.tapBoard('d4');
    g.tapBoard('d5');
    g.tapBoard('d6');
    expect(g.episode, 4);

    g.tapBoard('e1');
    g.tapBoard('e2');
    g.tapBoard('e3');
    g.tapBoard('e4');
    g.tapBoard('e5');
    g.tapBoard('e6');
    expect(g.flags.contains('board4ready'), isTrue);

    g.recoverTap(0);
    g.recoverTap(1);
    g.recoverTap(2);
    g.recoverTap(3);
    expect(g.flags.contains('alloyMelted'), isTrue);

    g.urlInput = 'ledger.kill';
    g.submitUrl();
    expect(g.campaignComplete, isTrue);
    expect(g.ending, 'kill');
  });

  test('hints are capped at three per task', () {
    final g = GameController(instant: true)..start();
    g.useHint();
    g.useHint();
    g.useHint();
    g.useHint();
    expect(g.hintsUsedOnTask, 3);
    expect(g.lastHint, contains('No more hints'));
  });
}
