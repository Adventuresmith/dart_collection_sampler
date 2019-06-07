import 'dart:math';

/// Samples collections
///
///
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
  List<T> pickN<T>(Iterable<T> items, int N, {bool unique = true}) {
    if (items == null) throw ArgumentError("items may not be null!");

    if (N <= 0) return <T>[];

    if (unique) {
      return reservoirSampling(items, N);
    } else {
      if (items is List) {
        return _pickNonUnique(items, N);
      } else {
        return _pickNonUnique(items.toList(growable: false), N);
      }
    }
  }

  /// pick N unique elements from an Iterable using reservoir sampling. should be O(N).
  ///
  /// 'unique' meaning no single position will be selected more than once. If the
  /// incoming collection has repeated values, then you may have repeated values in
  /// the sample.
  ///
  /// basic algorithm here https://en.wikipedia.org/wiki/Reservoir_sampling
  ///
  /// but, it's been modified to shuffle the initial reservoir -- the sample is
  /// relatively big compared to the # of items, then order within the sample is
  /// almost identical to the list.
  ///
  /// for example,
  ///    picking 5 items from [1,2,3,4,5,6,7,8,9]
  ///    could end up like    [1,6,3,4,5]
  ///
  List<T> reservoirSampling<T>(Iterable<T> items, int N) {
    var reservoir = List<T>(N);

    var shuffled = false;
    var ind = 0;
    var it = items.iterator;
    while (it.moveNext()) {
      if (ind < N) {
        // first N items, just add to reservoir
        reservoir[ind] = it.current;
      } else {
        if (!shuffled) {
          // if N is relatively 'big' compared to the size of the collection, then
          // the items are practically in-order as they are in the list.
          reservoir.shuffle(_random);
          shuffled = true;
        }
        // pick random index from 0 to ind
        var j = _random.nextInt(ind + 1);
        // if randomly picked index is smaller than N,
        // then replace the element present at the index
        // with new element from iterable
        if (j < N) {
          reservoir[j] = it.current;
        }
      }
      ind++;
    }
    return reservoir;
  }

  /// picks N items from Map (returning map values)
  Iterable<V> pickUniqueNFromMap<K, V>(Map<K, V> itemMap, int n) {
    return pickUniqueNFromMapAsMap(itemMap, n).values;
  }

  /// pick N unique values from the map. will return at most itemMap.length items
  Map<K, V> pickUniqueNFromMapAsMap<K, V>(Map<K, V> itemMap, int n) {
    if (itemMap == null) throw ArgumentError("itemMap may not be null!");

    return Map.fromIterable(reservoirSampling(itemMap.keys, n),
        key: (k) => k, value: (k) => itemMap[k]);
  }
}
