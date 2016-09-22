// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/info_section/info_section.dart';
import 'package:components_codelab/scores/scores.dart';
import 'package:components_codelab/settings/component/settings.dart';
import 'package:components_codelab/settings/settings_service.dart';
import 'package:components_codelab/visualize_winnings/visualize_winnings.dart';

const _fastPulse = const Duration(milliseconds: 5);

const _normalPulse = const Duration(milliseconds: 200);

@Component(
  selector: 'lottery-simulator',
  styleUrls: const ['lottery_simulator.css'],
  templateUrl: 'lottery_simulator.html',
  directives: const [
    materialDirectives,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    NgFor,
    NgIf,
    ScoresComponent,
    InfoSectionComponent,
    VisualizeWinningsComponent,
    SettingsComponent
  ],
  providers: const [materialBindings, Settings],
)
class AppComponent implements OnInit {
  final Settings _settings;

  Timer _pulse;

  /// The state of cash the person would have if they saved instead of betting.
  int altCash;

  int cash;

  int day;

  @ViewChild('vis')
  VisualizeWinningsComponent vis;

  /// The phase of the day.
  ///
  /// If `0`, it's when the user gets their income. If `1`, it's when they
  /// bet and invest.
  int phase;

  bool inProgress = false;

  final DateTime _today = new DateTime.now();

  /// A map that keeps track of how many occurrences of winning of a given
  /// value there were.
  ///
  /// In other words, `winningsMap[value] = occurrencesCount`.
  final Map<int, int> winningsMap = new Map<int, int>();

  bool _fastEnabled = false;

  AppComponent(this._settings);

  String get currentDay {
    var date = _today.add(new Duration(days: day));
    return "${date.month}/${date.day}/${date.year}";
  }

  bool get endOfDays => day >= _settings.maxDays;

  bool get fastEnabled => _fastEnabled;

  set fastEnabled(bool value) {
    _fastEnabled = value;
    if (inProgress) _reconfigurePulse();
  }

  bool get notEnoughMoney => cash < _settings.lottery.ticketPrice;

  int get progress => (day / _settings.maxDays * 100).round();

  Settings get settings => _settings;

  void bet() {
    int bettedToday = 0;
    int wonToday = 0;

    while (!notEnoughMoney &&
        settings.strategy
            .canContinue(bettedToday, wonToday, settings.dailyDisposable)) {
      cash -= _settings.lottery.ticketPrice;
      bettedToday += _settings.lottery.ticketPrice;
      var ticket = _settings.lottery.bet();
      cash += ticket.value;
      wonToday += ticket.value;

      // Visualize the result.
      if (ticket.value == 0) {
        vis.visualizeLoss();
      } else if (ticket.value < settings.dailyDisposable * 50) {
        vis.visualizeWin();
      } else {
        vis.visualizeBigWin();
      }
      winningsMap.putIfAbsent(ticket.value, () => 0);
      winningsMap[ticket.value] += 1;
    }
  }

  @override
  ngOnInit() {
    reset();
  }

  void pause() {
    _pulse?.cancel();
    inProgress = false;
  }

  void play() {
    inProgress = true;
    _reconfigurePulse();
  }

  void reset() {
    cash = _settings.initialCash;
    altCash = cash;
    day = 0;
    phase = 0;
    winningsMap.clear();
    vis.reset();
    pause();
  }

  /// Elapse one day.
  void step() {
    if (endOfDays) {
      pause();
      return;
    }

    // Add disposable money (phase 0).
    if (phase == 0) {
      day += 1;
      cash += _settings.dailyDisposable;
      altCash += _settings.dailyDisposable;
      phase = 1;
      return;
    }

    // Bet (phase 1)
    bet();

    // Add annual interest.
    if (day % 365 == 0) {
      double interest = altCash * (_settings.interestRate / 100);
      altCash += interest.floor();
    }
    phase = 0;
  }

  void updateFromSettings() {
    if (day == 0 && phase == 0) {
      cash = _settings.initialCash;
      altCash = cash;
    }
  }

  void _reconfigurePulse() {
    _pulse?.cancel();
    _pulse = new Timer.periodic(
        _fastEnabled ? _fastPulse : _normalPulse, (_) => step());
  }
}
