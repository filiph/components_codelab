// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/info_section/info_section.dart';
import 'package:components_codelab/scores/scores.dart';
import 'package:components_codelab/settings/component/settings.dart';
import 'package:components_codelab/settings/lottery.dart';
import 'package:components_codelab/settings/settings_service.dart';

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
    ScoresComponent,
    InfoSectionComponent,
    SettingsComponent
  ],
  providers: const [materialBindings, Settings],
)
class AppComponent implements OnInit {
  final Settings _settings;

  Settings get settings => _settings;

  Timer _pulse;

  /// The state of cash the person would have if they saved instead of betting.
  int altCash;

  int cash;

  int day;

  static const _fastPulse = const Duration(milliseconds: 5);
  static const _normalPulse = const Duration(milliseconds: 200);

  /// The phase of the day.
  ///
  /// If `0`, it's when the user gets their income. If `1`, it's when they
  /// bet and invest.
  int phase;

  bool inProgress = false;

  Queue<Ticket> latestTickets = new Queue<Ticket>();

  final DateTime _today = new DateTime.now();

  AppComponent(this._settings);

  String get currentDay {
    var date = _today.add(new Duration(days: day));
    return "${date.month}/${date.day}/${date.year}";
  }

  bool _fastEnabled = false;

  bool get fastEnabled => _fastEnabled;

  set fastEnabled(bool value) {
    _fastEnabled = value;
    if (inProgress) _reconfigurePulse();
  }

  void _reconfigurePulse() {
    _pulse?.cancel();
    _pulse = new Timer.periodic(
        _fastEnabled ? _fastPulse : _normalPulse, (_) => step());
  }

  bool get endOfDays => day >= _settings.maxDays;

  bool get notEnoughMoney => cash < _settings.lottery.ticketPrice;

  int get progress => (day / _settings.maxDays * 100).round();

  void bet() {
//    int maxBetValue = min(_settings.dailyMaxBet, cash);
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
      latestTickets.addLast(ticket);
      if (latestTickets.length > 10) latestTickets.removeFirst();
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
    latestTickets.clear();
    pause();
  }

  void updateFromSettings() {
    if (day == 0 && phase == 0) {
      cash = _settings.initialCash;
      altCash = cash;
    }
  }

  /// Elapse one day.
  void step() {
    if (endOfDays) {
      pause();
      return;
    }

    if (phase == 0) {
      day += 1;
      cash += _settings.dailyDisposable;
      altCash += _settings.dailyDisposable;
      phase = 1;
      return;
    }

    bet();

    if (day % 365 == 0) {
      double interest = altCash * (_settings.interestRate / 100);
      altCash += interest.floor();
      print("Interest: $interest");
    }
    phase = 0;
  }

  /// This tells [NgFor] that tickets with same value are equivalent, so that
  /// it doesn't rewrite DOM elements that would look the same before and after
  /// updating.
  ///
  /// See:
  /// https://angular.io/docs/dart/latest/guide/template-syntax.html#!#ngFor
  int trackByTickets(int index, Ticket ticket) => ticket.value;
}
