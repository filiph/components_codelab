// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/lottery/lottery.dart';
import 'package:components_codelab/settings/settings_service.dart';

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
  final interestRates = [0, 1, 3, 5, 10];

  @Output()
  EventEmitter<Null> settingsChanged = new EventEmitter<Null>();

  @Input()
  Settings settings;

  int initialCash;

  int dailyDisposable;

  int interestRate = 1;

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
  }


  void settingsUpdated() {
    settings.initialCash = initialCash;
    settings.dailyDisposable = dailyDisposable;
    settings.lottery = lottery;
    settings.strategy = strategy;
    settings.interestRate = interestRate;
    settingsChanged.add(null);
  }

  void updateDisposable(String value) {
    dailyDisposable = int.parse(value);
  }

  void updateInitial(String value) {
    initialCash = int.parse(value);
  }
}
