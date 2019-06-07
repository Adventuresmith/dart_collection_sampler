import 'dart:math';

import 'package:dart_dice_parser/dart_dice_parser.dart';

/// sampler that picks item from a List using die-roll results
///
class DiceSampler {
  DiceParser _diceParser;

  /// Constructs a new DiceSampler, optionally injected with a [DiceParser].
  DiceSampler([DiceParser dp]) {
    _diceParser = dp ?? DiceParser();
  }

  /// picks an item from the list, using the submitted dice expression to pick the item.
  ///
  /// this could be used to weight selections or filter out beginning/end.
  /// e.g. using 2d6 to pick a set of 12 items weighs selection to the middle
  /// or, using 1d6+2 to pick one of 12 items restricts the selection to items 3 through 8
  T pick<T>(String diceStr, List<T> items) {
    if (items == null) throw ArgumentError("items may not be null!");
    // dice are 1-based, list indexes are 0-based so subtract 1.
    var ind = _diceParser.roll(diceStr) - 1;
    // then clamp the dice roll to the acceptable range
    ind = min(items.length - 1, ind);
    ind = max(0, ind);
    return items.elementAt(ind);
  }
}
