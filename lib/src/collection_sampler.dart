
import 'dart:math';

/// ok to use if you've got a List
class ListSampler {
  Random _random;

  ListSampler([Random r]) {
    _random = r ?? new Random.secure();
  }

  /// pick an item at random from the list
  T pick<T>(List<T> items) {
    if (items == null) throw new ArgumentError("items may not be null!");
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = _random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }

  /// pick N unique items from the list. will return at most items.length items
  ///
  /// this creates a shallow copy of the list, shuffles it, then takes the first N items.
  Iterable<T> pickN<T>(List<T> items, int n) {
    if (items == null) throw new ArgumentError("items may not be null!");
    if (n <= 0)
      return [];

    var shallowCopy = new List.from(items);
    shallowCopy.shuffle(_random);
    return shallowCopy.take(n);
  }
}


class MapSampler {
  ListSampler _listSampler;

  MapSampler([Random r]) {
    _listSampler = new ListSampler(r);
  }

  /// pick an value at random from the map
  V pick<K,V>(Map<K,V> itemMap) {
    if (itemMap == null) throw new ArgumentError("itemMap may not be null!");

    return itemMap[_listSampler.pick(itemMap.keys.toList(growable: false))];
  }

  /// pick N unique values from the map. will return at most itemMap.length items
  Map<K,V> pickNtoMap<K,V>(Map<K,V> itemMap, int n) {
    if (itemMap == null) throw new ArgumentError("itemMap may not be null!");

    return new Map.fromIterable(
      _listSampler.pickN(itemMap.keys.toList(growable: false), n),
      key: (k) => k,
      value: (k) => itemMap[k]
    );
  }
  Iterable<V> pickN<K,V>(Map<K,V> itemMap, int n) {
    return pickNtoMap(itemMap, n).values;
  }
}