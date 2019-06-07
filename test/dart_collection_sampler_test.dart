import 'dart:math';

import 'package:dart_collection_sampler/dart_collection_sampler.dart';
import 'package:dart_dice_parser/dart_dice_parser.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockRandom extends Mock implements Random {}

void main() {
  setUp(() async {});
  group('dice sampler', () {
    DiceParser diceParser;
    setUp(() {
      var mockRandom = MockRandom();
      diceParser = DiceParser(diceRoller: DiceRoller(mockRandom));

      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000))))
          .thenReturn(1);
    });

    test('sample ints', () {
      var sampler = DiceSampler(diceParser);
      // nextInt returns 1, dice roller adds 1... 2+2=4
      expect(sampler.pick("2d6", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
          equals(4));
    });
    test('sample strings', () {
      var sampler = DiceSampler(diceParser);
      expect(sampler.pick("2d6", ["a", "b", "c", "d", "e"]), equals("d"));
    });
  });

  group("list sampler", () {
    MockRandom mockRandom;

    setUp(() {
      mockRandom = MockRandom();
      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000))))
          .thenReturn(1);
    });

    test('pick int', () {
      var sampler = CollectionSampler(mockRandom);
      expect(
          sampler.pick([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]), equals(1));
    });
    test('pickN', () {
      var sampler = CollectionSampler(mockRandom);
      expect(sampler.pickN([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 3),
          equals([0, 12, 1]));
    });
  });

  group("map sampler", () {
    var input = {0: "a", 1: "b", 2: "c", 3: "d", 4: "e"};

    MockRandom mockRandom;

    setUp(() {
      mockRandom = MockRandom();
      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000))))
          .thenReturn(1);
    });

    test('pick from map', () {
      var sampler = CollectionSampler(mockRandom);
      expect(sampler.pickFromMap(input), equals('b'));
    });
    test('pickNFromMapAsMap', () {
      var sampler = CollectionSampler(mockRandom);
      expect(sampler.pickUniqueNFromMapAsMap(input, 3),
          equals({0: "a", 4: "e", 1: "b"}));
    });
    test('pickNFromMap', () {
      var sampler = CollectionSampler(mockRandom);
      expect(sampler.pickUniqueNFromMap(input, 3), equals(["a", "e", "b"]));
    });
  });
}
