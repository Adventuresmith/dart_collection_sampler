import 'package:dart_collection_sampler/dart_collection_sampler.dart';
import 'package:dart_dice_parser/dart_dice_parser.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'dart:math';

class MockRandom extends Mock implements Random {}

void main() {
  var mockRandom = new MockRandom();

  group('dice sampler', () {

    var roller = new DiceRoller(mockRandom);
    var diceParser = new DiceParser(roller);

    setUp(() {
    });

    test('First Test', () {
      var sampler = new DiceSampler(diceParser);

      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000)))).thenReturn(1);

      // nextInt returns 1, dice roller adds 1... 2+2=4
      expect(sampler.pick("2d6", [1,2,3,4,5,6,7,8,9,10,11,12]), equals(4));
      expect(sampler.pick("2d6", ["a","b","c","d","e"]), equals("d"));
    });
  });
}
