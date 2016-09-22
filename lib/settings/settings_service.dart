import 'dart:math';

import 'package:angular2/core.dart';

import 'lottery.dart';

final DateTime _now = new DateTime.now();

typedef bool Inhibitor(int bettedToday, int wonToday, int dailyDisposable);

@Injectable()
class Settings {
  int initialCash = 20;

  /// The amount of cash that the player has on them each new day.
  int dailyDisposable = 2; // TODO: use strategy

  Strategy strategy = Strategy._strategies.first;

  int interestRate = 1;

  int years = 3;

  Lottery lottery = Lottery.lotteries.first;

  DateTime get now => _now;

  Settings();

  List<Lottery> get lotteries => Lottery.lotteries;

  int get maxDays => new DateTime(
          _now.year + years, _now.month, _now.day, _now.hour, _now.minute)
      .difference(_now)
      .inDays;

  List<Strategy> get strategies => Strategy._strategies;
}

class Strategy {
  static final conservative = new Strategy(
      "Conservative",
      "only disposable income",
      "Buy lottery tickets up to the daily disposable income.",
      (bettedToday, wonToday, dailyDisposable) =>
          bettedToday < dailyDisposable);

  static final reinvest = new Strategy(
      "Reinvest",
      "disposable income and winnings",
      "Re-invest the day's winning tickets to buy new ones (unless the "
      "winnings are 10x more than the daily disposable income).",
      (bettedToday, wonToday, dailyDisposable) =>
          bettedToday < dailyDisposable + wonToday &&
          wonToday < dailyDisposable * 10);

  static final allIn = new Strategy(
      "All in",
      "everything",
      "Use all available cash to buy tickets every day (even if we just won "
      "the jackpot — bet it all back).",
      (bettedToday, wonToday, dailyDisposable) => true);

  static final List<Strategy> _strategies = [conservative, reinvest, allIn];

  final String shortName;

  final String name;

  final String description;

  final Inhibitor canContinue;

  Strategy(this.shortName, this.name, this.description, this.canContinue);
}
