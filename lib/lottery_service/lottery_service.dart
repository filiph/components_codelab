import 'dart:math';

import 'package:angular2/core.dart';

@Injectable()
class SimpleLottery {
  final Random _random;
  final ticketPrice = 1;

  SimpleLottery(this._random);

  Ticket bet() {
    num draw = _random.nextDouble();
    if (draw < 0.01) {
      return new Ticket(50, Category.jackpot);
    }
    if (draw < 0.1) {
      return new Ticket(5, Category.win);
    }
    return new Ticket(0, Category.lose);
  }
}

@Injectable()
class Powerball implements SimpleLottery {
  final Random _random;
  final ticketPrice = 2;
  final jackpot = 40000000;

  Powerball(this._random);

  /// Chances according to http://www.powerball.com/powerball/pb_prizes.asp.
  Ticket bet() {
//    if (value < ticketPrice) throw "Smallest bet is $ticketPrice";

    // Return winning plus anything over value.
  }
}

class Ticket {
  final int value;
  final Category category;

  Ticket(this.value, this.category);
}

enum Category { jackpot, win, lose }
