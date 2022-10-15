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
  group('dice sampler', () {
    test('sample ints', () {
      final sampler = DiceSampler(seededRandom);
      expect(
        sampler.pick("2d6", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
        equals(8), // 2d6 will be 6+2=8
      );
    });
    test('sample strings', () {
      final sampler = DiceSampler(seededRandom);
      expect(
        sampler.pick("2d6", ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]),
        equals("h"), // 2d6 will be 6+2=8
      );
    });
  });
}
