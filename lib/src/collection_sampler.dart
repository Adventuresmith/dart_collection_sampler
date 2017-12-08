
import 'dart:math';

class CollectionSampler {
  Random _random;

  CollectionSampler([Random r]) {
    _random = r ?? new Random.secure();
  }

  /// pick an item at random from the list -- restricted to List because size is known,
  /// and elementAt is implemented efficiently.
  T pick<T>(List<T> items) {
    if (items == null) throw new ArgumentError("items may not be null!");
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = _random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }

  /// pick N non-uniquely
  List<T> _pickNonUnique<T>(List<T> items, int N) {
    var result = <T>[];
    for (int i = 0; i < N; i++) {
      result.add(pick(items));
    }
    return result;
  }

  /// pick an value at random from the map
  V pickFromMap<K,V>(Map<K,V> itemMap) {
    if (itemMap == null) throw new ArgumentError("itemMap may not be null!");

    return itemMap[pick(itemMap.keys.toList(growable: false))];
  }


  List<T> pickN<T>(Iterable<T> items, int N, {bool unique = true}) {
    if (items == null) throw new ArgumentError("items may not be null!");

    if (N <= 0)
      return <T>[];

    if (unique) {
      return _reservoirSampling(items, N);
    } else {
      if (items is List) {
        return _pickNonUnique(items, N);
      } else {
        return _pickNonUnique(items.toList(growable: false), N);
      }
    }
  }

  /// pick N unique things from an Iterable using reservoir sampling. should be O(N).
  ///
  /// algorithm here https://en.wikipedia.org/wiki/Reservoir_sampling
  List<T> _reservoirSampling<T>(Iterable<T> items, int N) {
    var reservoir = <T>[];

    var shuffled = false;
    var ind = 0;
    var it = items.iterator;
    while (it.moveNext()) {
      if (ind < N) {
        // first N items, just add to reservoir
        reservoir.add(it.current);
      } else {
        if (!shuffled) {
          // if N is relatively 'big' compared to the size of the collection, then
          // the items are practically in-order as they are in the list.
          reservoir.shuffle(_random);
          shuffled = true;
        }
        // pick random index from 0 to ind
        int j = _random.nextInt(ind + 1);
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

  Iterable<V> pickUniqueNFromMap<K,V>(Map<K,V> itemMap, int n) {
    return pickUniqueNFromMapAsMap(itemMap, n).values;
  }

  /// pick N unique values from the map. will return at most itemMap.length items
  Map<K,V> pickUniqueNFromMapAsMap<K,V>(Map<K,V> itemMap, int n) {
    if (itemMap == null) throw new ArgumentError("itemMap may not be null!");

    return new Map.fromIterable(
      _reservoirSampling(itemMap.keys, n),
      key: (k) => k,
      value: (k) => itemMap[k]
    );
  }
}