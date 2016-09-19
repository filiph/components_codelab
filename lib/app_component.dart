// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:html';

import 'dart:math';
import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/lottery_service/lottery_service.dart';
import 'package:components_codelab/settings/settings_service.dart';

@Component(
  selector: 'my-app',
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

  Queue<Ticket> latestTickets = new Queue<Ticket>();

  @ViewChild('betOnce')
  MaterialButtonComponent betOnceButton;

  AppComponent(this._settings, this._lottery);

  int get defaultBet => min(_settings.dailyMaxBet, cash);

  bool get endOfDays => day >= _settings.maxDays;

  bool get notEnoughMoney => cash < _lottery.smallestBet;

  void bet() {
    if (notEnoughMoney) return;
    int betValue = defaultBet;
    cash -= betValue;
    var ticket = _lottery.bet(betValue);
    cash += ticket.value;
    latestTickets.addLast(ticket);
    if (latestTickets.length > 10) latestTickets.removeFirst();
  }

  @override
  ngOnInit() {
    reset();
  }

  void pause() {
    _pulse.cancel();
  }

  void play() {
    _pulse = new Timer.periodic(const Duration(milliseconds: 1), step);
  }

  void reset() {
    cash = _settings.initialCash;
    altCash = cash;
    day = 0;
    latestTickets.clear();
  }

  /// Elapse one day.
  void step(Timer _) {
    if (endOfDays) {
      pause();
      return;
    }

    day += 1;
    cash += _settings.dailyDisposable;
    altCash += _settings.dailyDisposable;

    bet();

    if (day % 365 == 0) {
      double interest = altCash * _settings.interestRate;
      altCash += interest.floor();
      print("Interest: $interest");
    }
  }

  /// This tells [NgFor] that tickets with same value are equivalent, so that
  /// it doesn't rewrite DOM elements that would look the same before and after
  /// updating.
  ///
  /// See:
  /// https://angular.io/docs/dart/latest/guide/template-syntax.html#!#ngFor
  int trackByTickets(int index, Ticket ticket) => ticket.value;
}
