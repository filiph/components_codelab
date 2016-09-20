// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:components_codelab/settings/settings_service.dart';

@Component(
  selector: 'settings-component',
  styleUrls: const ['settings.css'],
  templateUrl: 'settings.html',
  directives: const [MaterialExpansionPanel, MaterialExpansionPanelSet],
  providers: const [materialBindings],
)
class SettingsComponent implements OnInit {
  @Output()
  EventEmitter<Null> settingsChanged = new EventEmitter<Null>();

  @Input()
  Settings settings;

  int initialCash;
  int dailyDisposable;

  void updateInitial(String value) {
    initialCash = int.parse(value);
  }

  void updateDisposable(String value) {
    dailyDisposable = int.parse(value);
  }

  void settingsUpdated() {
    settings.initialCash = initialCash;
    settings.dailyDisposable = dailyDisposable;
    settingsChanged.add(null);
  }

  @override
  ngOnInit() {
    initialCash = settings.initialCash;
    dailyDisposable = settings.dailyDisposable;
  }
}
