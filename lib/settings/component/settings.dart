// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/settings/settings_service.dart';
import 'package:components_codelab/settings/lottery.dart';

@Component(
  selector: 'settings-component',
  styleUrls: const ['settings.css'],
  templateUrl: 'settings.html',
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
  @Output()
  EventEmitter<Null> settingsChanged = new EventEmitter<Null>();

  @Input()
  Settings settings;

  int initialCash;
  int dailyDisposable;

  Lottery lottery;

  BetCeiling betCeiling;

  @override
  ngOnInit() {
    resetWallet();
    resetBetting();
  }

  void settingsUpdated() {
    settings.initialCash = initialCash;
    settings.dailyDisposable = dailyDisposable;
    settings.lottery = lottery;
    settings.betCeiling = betCeiling;
    settingsChanged.add(null);
  }

  void updateDisposable(String value) {
    dailyDisposable = int.parse(value);
  }

  void updateInitial(String value) {
    initialCash = int.parse(value);
  }

  void resetWallet() {
    initialCash = settings.initialCash;
    dailyDisposable = settings.dailyDisposable;
  }

  void resetBetting() {
    lottery = settings.lottery;
    betCeiling = settings.betCeiling;
  }
}
