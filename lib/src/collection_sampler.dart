import 'package:quiver/check.dart';

import 'dart:math';


class CollectionSampler {
  Random _random;

  CollectionSampler([Random r]) {
    _random = r ?? new Random.secure();
  }

  /// pick an item at random from the iterable
  T pick<T>(Iterable<T> items) {
    checkNotNull(items);
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = _random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }


  /// pick an value at random from the map
  V pickMap<K,V>(Map<K,V> itemMap) {
    checkNotNull(itemMap);
    var keys = itemMap.keys;
    var index = _random.nextInt(keys.length) % keys.length;

    var k = keys.elementAt(index);

    return itemMap[k];
  }

  /// pick N unique items from the iterable. will return at most items.length items
  ///
  /// this creates a shallow copy of the list, shuffles it, then takes the first N items. not efficient.
  List<T> pickN<T>(Iterable<T> items, int n) {
    checkNotNull(items);
    if (n <= 0)
      return [];

    var shallowCopy = new List.from(items);
    shallowCopy.shuffle(_random);
    return shallowCopy.take(n);
  }

  /// pick N unique values from the map. will return at most itemMap.length items
  List<V> pickMapN<K,V>(Map<K,V> itemMap, int n) {
    checkNotNull(itemMap);
    if (n <= 0)
      return [];
    var keys = itemMap.keys;
    // pick N unique keys from map

    var pickedKeys = pickN(itemMap.keys, n);
    return pickedKeys.map((key) => itemMap[key]);
  }

}