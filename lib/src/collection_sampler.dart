import 'dart:math';

import 'package:dart_collection_sampler/src/reservoir_sampling.dart';

/// Samples collections
///
/// selecting N items from collections is done via Resevoir Sampling,
/// see [reservoirSampling] for more details.
class CollectionSampler {
  Random _random;

  /// Construct new collection sampler w/ injectible random
  CollectionSampler([Random r]) {
    _random = r ?? Random.secure();
  }

  /// pick an item at random from the list -- restricted to List because size is known,
  /// and elementAt is implemented efficiently.
  T pick<T>(List<T> items) {
    if (items == null) throw ArgumentError("items may not be null!");
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = _random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }

  /// pick N non-uniquely
  List<T> _pickNonUnique<T>(List<T> items, int N) {
    var result = <T>[];
    for (var i = 0; i < N; i++) {
      result.add(pick(items));
    }
    return result;
  }

  /// pick an value at random from the map
  V pickFromMap<K, V>(Map<K, V> itemMap) {
    if (itemMap == null) throw ArgumentError("itemMap may not be null!");

    return itemMap[pick(itemMap.keys.toList(growable: false))];
  }

  /// Picks N items from iterable, optionally make it unique.
  ///
  /// if unique, uses [reservoirSampling].
  List<T> pickN<T>(Iterable<T> items, int N, {bool unique = true}) {
    if (items == null) throw ArgumentError("items may not be null!");

    if (N <= 0) return <T>[];

    if (unique) {
      return reservoirSampling(items, N, _random);
    } else {
      if (items is List) {
        return _pickNonUnique(items, N);
      } else {
        return _pickNonUnique(items.toList(growable: false), N);
      }
    }
  }

  /// picks N items from Map (returning map values)
  Iterable<V> pickUniqueNFromMap<K, V>(Map<K, V> itemMap, int n) {
    return pickUniqueNFromMapAsMap(itemMap, n).values;
  }

  /// pick N unique values from the map. will return at most itemMap.length items
  Map<K, V> pickUniqueNFromMapAsMap<K, V>(Map<K, V> itemMap, int n) {
    if (itemMap == null) throw ArgumentError("itemMap may not be null!");

    return Map.fromIterable(reservoirSampling(itemMap.keys, n, _random),
        key: (k) => k, value: (k) => itemMap[k]);
  }
}
