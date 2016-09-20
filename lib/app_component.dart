// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/lottery_service/lottery_service.dart';
import 'package:components_codelab/settings/settings_service.dart';

@Component(
  selector: 'lottery-simulator',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    NgFor
  ],
  providers: const [materialBindings, SimpleLottery, Settings],
)
class AppComponent implements OnInit {
  final SimpleLottery _lottery;
  final Settings _settings;

  Timer _pulse;

  /// The state of cash the person would have if they saved instead of betting.
  int altCash;

  int cash;

  int day;

  /// The phase of the day.
  ///
  /// If `0`, it's when the user gets their income. If `1`, it's when they
  /// bet and invest.
  int phase;

  Queue<Ticket> latestTickets = new Queue<Ticket>();

  final DateTime _today = new DateTime.now();

  AppComponent(this._settings, this._lottery);

  String get currentDay {
    var date = _today.add(new Duration(days: day));
    return "${date.month}/${date.day}/${date.year}";
  }

  bool get endOfDays => day >= _settings.maxDays;

  bool get notEnoughMoney => cash < _lottery.ticketPrice;

  String get outcomeDescription {
    if (cash == altCash) return "no difference";
    double multiple = cash / altCash;
    if (cash > altCash) {
      int percentage = ((multiple - 1) * 100).round();
      return "$percentage% better";
    }
    int percentage = ((1 - multiple) * 100).round();
    return "$percentage% worse";
  }

  int get progress => (day / _settings.maxDays * 100).round();

  void bet() {
    if (notEnoughMoney) return;
    int maxBetValue = min(_settings.dailyMaxBet, cash);
    while (maxBetValue >= _lottery.ticketPrice) {
      cash -= _lottery.ticketPrice;
      var ticket = _lottery.bet();
      cash += ticket.value;
      latestTickets.addLast(ticket);
      if (latestTickets.length > 10) latestTickets.removeFirst();
      maxBetValue -= _lottery.ticketPrice;
    }
  }

  @override
  ngOnInit() {
    reset();
  }

  void pause() {
    _pulse.cancel();
  }

  void play() {
    _pulse = new Timer.periodic(const Duration(milliseconds: 100), step);
  }

  void reset() {
    cash = _settings.initialCash;
    altCash = cash;
    day = 0;
    phase = 0;
    latestTickets.clear();
  }

  /// Elapse one day.
  void step(Timer _) {
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
      double interest = altCash * _settings.interestRate;
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
