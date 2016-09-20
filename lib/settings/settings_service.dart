import 'dart:math';
import 'package:angular2/core.dart';

import 'lottery.dart';

@Injectable()
class Settings {
  int initialCash = 20;

  /// The amount of cash that the player has on them each new day.
  int dailyDisposable = 2;

  int dailyMaxBet = 2;

  double interestRate = 0.01;

  final int maxDays = (10) * 365;

  Lottery lottery = new Powerball(new Random());

  Settings();
}
