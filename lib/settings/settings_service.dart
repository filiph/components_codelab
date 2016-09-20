import 'dart:math';
import 'package:angular2/core.dart';

@Injectable()
class Settings {
  int initialCash = 20;

  /// The amount of cash that the player has on them each new day.
  int dailyDisposable = 1;

  int dailyMaxBet = 10;

  double interestRate = 0.01;

  final int maxDays = (10) * 365;

  Settings();
}
