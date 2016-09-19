// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:collection';
import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/lottery_service/lottery_service.dart';

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
  providers: const [materialBindings, SimpleLottery],
)
class AppComponent {
  final SimpleLottery _lottery;
  Timer _pulse;
  int cash = 20;
  int defaultBet = 1;
  Queue<Ticket> latestTickets = new Queue<Ticket>();
//  @ViewChild('betOnce')
//  ElementRef _betOnceButton;

  AppComponent(this._lottery);

  /// Elapse one day.
  void step(Timer _) {
    // TODO: increase day
//    bet();
//    _button.trigger.add(new MouseEvent('click'));
    // TODO: invest
  }

  void bet() {
    // TODO: ask wallet how much money we can bet
    cash -= defaultBet;
    var ticket = _lottery.bet(defaultBet);
    cash += ticket.value;
    latestTickets.addLast(ticket);
    if (latestTickets.length > 10) latestTickets.removeFirst();
  }

  /// This tells [NgFor] that tickets with same value are equivalent, so that
  /// it doesn't rewrite DOM elements that would look the same before and after
  /// updating.
  ///
  /// See:
  /// https://angular.io/docs/dart/latest/guide/template-syntax.html#!#ngFor
  int trackByTickets(int index, Ticket ticket) => ticket.value;

  void play() {
    _pulse = new Timer.periodic(const Duration(milliseconds: 200), step);
  }

  void pause() {
    _pulse.cancel();
  }
}
