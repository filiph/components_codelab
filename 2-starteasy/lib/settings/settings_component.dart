// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:components_codelab/lottery/lottery.dart';
import 'package:components_codelab/settings/settings.dart';

@Component(
  selector: 'settings-component',
  styleUrls: const ['settings_component.css'],
  templateUrl: 'settings_component.html',
  directives: const [
    NgFor
  ],
)
class SettingsComponent implements OnInit {
  final initialCashOptions = [0, 10, 100, 1000];

  final dailyDisposableOptions = [0, 2, 4, 10];

  final interestRateOptions = [1, 3, 5, 10];

  final yearsOptions = [1, 2, 3, 5, 10];

  @Output()
  EventEmitter<Null> settingsChanged = new EventEmitter<Null>();

  @Input()
  Settings settings;

  int initialCash;

  int dailyDisposable;

  bool isInvesting = true;

  int interestRate;

  int years;

  Lottery lottery;

  Strategy strategy;

  @override
  ngOnInit() {
    resetWallet();
    resetBetting();
    resetOther();
  }

  void resetBetting() {
    lottery = settings.lottery;
    strategy = settings.strategy;
  }

  void resetWallet() {
    initialCash = settings.initialCash;
    dailyDisposable = settings.dailyDisposable;
  }

  void resetOther() {
    if (settings.interestRate == 0) {
      isInvesting = false;
    } else {
      isInvesting = true;
      interestRate = settings.interestRate;
    }
    years = settings.years;
  }


  void settingsUpdated() {
    settings.initialCash = initialCash;
    settings.dailyDisposable = dailyDisposable;
    settings.lottery = lottery;
    settings.strategy = strategy;
    settings.interestRate = isInvesting ? interestRate : 0;
    settings.years = years;
    settingsChanged.add(null);
  }
}
