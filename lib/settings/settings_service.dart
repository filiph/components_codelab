import 'dart:math';

import 'package:angular2/core.dart';

import 'lottery.dart';

class BetCeiling {
  final String shortName;
  final String name;
  final String description;

  BetCeiling(this.shortName, this.name, this.description);
}

@Injectable()
class Settings {
  int initialCash = 20;

  /// The amount of cash that the player has on them each new day.
  int dailyDisposable = 2;

  int dailyMaxBet = 2; // TODO: use betCeiling

  static final List<BetCeiling> _betCeilings = [
    new BetCeiling("Conservative","only disposable income",
        "Buy lottery tickets up to the daily disposable income."),
    new BetCeiling("Reinvest", "disposable income and winnings",
        "Re-invest the day's winning tickets to buy new ones."),
    new BetCeiling("All in",
        "everythig", "Use all available cash to buy tickets every day.")
  ];

  List<BetCeiling> get betCeilings => _betCeilings;

  BetCeiling betCeiling = _betCeilings.first;

  double interestRate = 0.01;

  final int maxDays = (10) * 365;

  static final List<Lottery> _lotteries = [
    new Powerball(new Random()),
    new SimpleLottery(new Random())
  ];

  List<Lottery> get lotteries => _lotteries;

  Lottery lottery = _lotteries.first;

  Settings();
}
