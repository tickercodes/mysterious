# The Desk

A complete Flutter crime story in the style of **An Elmwood Trail**: two phones, messenger interrogation, the victim’s locked device, voicemail, typed-URL browser, corrupted files, a case board, a town social feed, and three hints per task.

You play **Rowan Hale**, night archivist at *The Marrow Bay Ledger*. At 2:17 a.m. an unknown sender texts you an obituary that has not happened yet. At 6:02 it has. Then they put Vera Quinn’s phone in your hand.

The early edition does not predict death. It **collects** names. Marrow Bay’s 1894 charter keeps the harbor “bound” so long as an obituary sits on the desk before dawn.

## Play

```bash
flutter pub get
flutter run -d chrome
```

Four editions. One last line.

1. **The Ink Tray** — Warn Vera. Unlock her phone (`0217`). Recover Sable. Call Ellis. Type `ledger.early`. Notes: `JUNE`. Match three proofs. Answer Camille as a dead woman.
2. **Job Ticket 1102** — Ruth Calder, retired compositor, is in the tray. Recover her file (ticket first). Call `207-555-1102`. Type `job1102.ledger`. Notes: `CASLON`.
3. **The Ninth Window** — Type `room9.ledger`, bind the page, read `charter.ledger`, Notes: `NINTH`. Learn who held the rope in 1999.
4. **Special Edition** — Match the last proofs. Melt `1894 / 1999 / 2:17 / 6:02`. Type **one** URL:
   - `ledger.spike` — June becomes weather. You keep the job.
   - `crowe.obit` — the mayor feeds the tray. Sable keeps a yesterday.
   - `ledger.kill` — the desk dies. Go inland.

Stuck: tap **HINT** on the red task bar (3 per task). Pier Feed is the town’s official lie.

## Art

Cinematic stills in `assets/images/`. Newspaper-noir palette on a custom phone OS (MarrowOS).
