// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/lottery/lottery.dart';
import 'package:components_codelab/settings/settings.dart';

@Component(
  selector: 'settings-component',
  styleUrls: const ['settings_component.css'],
  templateUrl: 'settings_component.html',
  directives: const [
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    NgFor
  ],
  providers: const [materialBindings],
)
class SettingsComponent implements OnInit {
  final interestRateOptions = [0, 1, 3, 5, 10];
  final yearsOptions = [1, 2, 3, 5, 10];

  @Output()
  EventEmitter<Null> settingsChanged = new EventEmitter<Null>();

  @Input()
  Settings settings;

  int initialCash;

  int dailyDisposable;

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
    interestRate = settings.interestRate;
    years = settings.years;
  }


  void settingsUpdated() {
    settings.initialCash = initialCash;
    settings.dailyDisposable = dailyDisposable;
    settings.lottery = lottery;
    settings.strategy = strategy;
    settings.interestRate = interestRate;
    settings.years = years;
    settingsChanged.add(null);
  }

  void updateDisposable(String value) {
    try {
      dailyDisposable = int.parse(value);
    } on FormatException {
      // Pass
    }
  }

  void updateInitial(String value) {
    try {
      initialCash = int.parse(value);
    } on FormatException {
      // Pass
    }
  }
}
