import 'dart:math';

import 'package:angular2/core.dart';

@Injectable()
class SimpleLottery {
  final Random _random;
  final smallestBet = 1;

  SimpleLottery(this._random);

  Ticket bet(int value) {
    if (value < smallestBet) throw "Smallest bet is $smallestBet";
    num draw = _random.nextDouble();
    if (draw < 0.01) {
      return new Ticket(value * 50, Category.jackpot);
    }
    if (draw < 0.1) {
      return new Ticket(value * 5, Category.win);
    }
    return new Ticket(0, Category.lose);
  }
}

class Ticket {
  final int value;
  final Category category;

  Ticket(this.value, this.category);
}

enum Category {
  jackpot, win, lose
}