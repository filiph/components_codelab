// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
import 'package:components_codelab/lottery_simulator.dart';

main() {
  bootstrap(AppComponent, [provide(Random, useValue: new Random())]);
}
