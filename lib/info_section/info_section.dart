// Copyright (c) 2016, Filip Hracek. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';

@Component(
  selector: 'info-section',
  styleUrls: const ['info_section.css'],
  templateUrl: 'info_section.html',
  directives: const [MaterialTabComponent, MaterialTabPanelComponent],
  providers: const [materialBindings],
)
class InfoSectionComponent {}
