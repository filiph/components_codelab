import 'dart:math';

import 'package:angular2/core.dart';

abstract class Lottery {
  int get ticketPrice;
  Ticket bet();
}

class SimpleLottery implements Lottery {
  final Random _random;
  final ticketPrice = 1;

  SimpleLottery(this._random);

  Ticket bet() {
    double draw = _random.nextDouble();
    if (draw < 0.01) {
      return new Ticket(50, Category.jackpot);
    }
    if (draw < 0.1) {
      return new Ticket(5, Category.win);
    }
    return new Ticket(0, Category.lose);
  }
}

class Powerball implements Lottery {
  final Random _random;
  final ticketPrice = 2;
  final jackpot = 40000000;

  Powerball(this._random);

  /// Chances according to http://www.powerball.com/powerball/pb_prizes.asp.
  Ticket bet() {
    double draw = _random.nextDouble();

    if (draw < 1 / 292201338.0) {
      return new Ticket(jackpot, Category.jackpot);
    }
    if (draw < 1 / 11688053.52) {
      return new Ticket(1000000, Category.win);
    }
    if (draw < 1 / 913129.18) {
      return new Ticket(50000, Category.win);
    }
    if (draw < 1 / 36525.17) {
      return new Ticket(100, Category.win);
    }
    if (draw < 1 / 14494.11) {
      return new Ticket(100, Category.win);
    }
    if (draw < 1 / 579.76) {
      return new Ticket(7, Category.win);
    }
    if (draw < 1 / 701.33) {
      return new Ticket(7, Category.win);
    }
    if (draw < 1 / 91.98) {
      return new Ticket(4, Category.win);
    }
    if (draw < 1 / 38.32) {
      return new Ticket(4, Category.win);
    }
    return new Ticket(0, Category.lose);
  }
}

class Ticket {
  final int value;
  final Category category;

  Ticket(this.value, this.category);
}

enum Category { jackpot, win, lose }
