import 'package:dart_collection_sampler/dart_collection_sampler.dart';
import 'package:dart_dice_parser/dart_dice_parser.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'dart:math';

class MockRandom extends Mock implements Random {}

void main() {

  group('dice sampler', () {

    var mockRandom = new MockRandom();
    var roller = new DiceRoller(mockRandom);
    var diceParser = new DiceParser(roller);

    setUp(() {
      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000)))).thenReturn(1);
    });

    test('sample ints', () {
      var sampler = new DiceSampler(diceParser);
      // nextInt returns 1, dice roller adds 1... 2+2=4
      expect(sampler.pick("2d6", [1,2,3,4,5,6,7,8,9,10,11,12]), equals(4));
    });
    test('sample strings', () {
      var sampler = new DiceSampler(diceParser);
      expect(sampler.pick("2d6", ["a","b","c","d","e"]), equals("d"));
    });
  });

  group("list sampler", () {
    var mockRandom = new MockRandom();

    setUp(() {
      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000)))).thenReturn(1);
    });

    test('pick int', () {
      var sampler = new CollectionSampler(mockRandom);
      expect(sampler.pick([0,1,2,3,4,5,6,7,8,9,10,11,12]), equals(1));
    });
    test('pickN', () {
      var sampler = new CollectionSampler(mockRandom);
      expect(sampler.pickN([0,1,2,3,4,5,6,7,8,9,10,11,12], 3), equals([0,12,1]));
    });
  });

  group("map sampler", () {
    var mockRandom = new MockRandom();
    var input = {
      0: "a",
      1: "b",
      2: "c",
      3: "d",
      4: "e"
    };

    setUp(() {
      when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000)))).thenReturn(1);
    });

    test('pick from map', () {
      var sampler = new CollectionSampler(mockRandom);
      expect(sampler.pickFromMap(input), equals('b'));
    });
    test('pickNFromMapAsMap', () {
      var sampler = new CollectionSampler(mockRandom);
      expect(sampler.pickUniqueNFromMapAsMap(input, 3), equals({0: "a", 4: "e", 1: "b"}));
    });
    test('pickNFromMap', () {
      var sampler = new CollectionSampler(mockRandom);
      expect(sampler.pickUniqueNFromMap(input, 3), equals(["a", "e", "b"]));
    });
  });
}
