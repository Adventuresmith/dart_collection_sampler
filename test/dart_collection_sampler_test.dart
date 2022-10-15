import 'dart:math';

import 'package:dart_collection_sampler/dart_collection_sampler.dart';
import 'package:test/test.dart';

void main() {
  late Random seededRandom;
  setUp(() async {
    // first 100 seeded rolls for d6
    // [6, 2, 1, 5, 3, 5, 1, 4, 6, 5, 6, 4, 2, 4, 2, 3, 5, 1, 1, 2, 4, 1, 6, 2, 2, 5, 6, 3, 1, 3, 6, 1, 2, 3, 6, 2, 1, 1, 1, 3, 1, 2, 3, 3, 6, 2, 5, 4, 3, 4, 1, 5, 4, 4, 2, 6, 5, 4, 6, 2, 3, 1, 4, 5, 3, 2, 2, 6, 6, 4, 4, 2, 6, 2, 5, 3, 3, 4, 4, 2, 2, 4, 3, 2, 6, 6, 4, 6, 4, 4, 3, 1, 4, 2, 2, 4, 3, 3, 1, 3]

    seededRandom = Random(1234);
  });

  group("list sampler", () {
    test('pick int', () {
      final sampler = CollectionSampler(seededRandom);
      expect(
        sampler.pick([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
        equals(1),
      );
    });
    test('pickN', () {
      final sampler = CollectionSampler(seededRandom);

      expect(
        sampler.pickN([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 3),
        equals([6, 2, 11]),
      );
    });
  });

  group("map sampler", () {
    final input = {0: "a", 1: "b", 2: "c", 3: "d", 4: "e"};

    test('pick from map', () {
      final sampler = CollectionSampler(seededRandom);
      expect(sampler.pickFromMap(input), equals('a'));
    });
    test('pickNFromMapAsMap', () {
      final sampler = CollectionSampler(seededRandom);
      expect(
        sampler.pickUniqueNFromMapAsMap(input, 3),
        equals({2: 'c', 0: 'a', 1: 'b'}),
      );
    });
    test('pickNFromMap', () {
      final sampler = CollectionSampler(seededRandom);
      expect(sampler.pickUniqueNFromMap(input, 3), equals(["c", "a", "b"]));
    });
  });
}
