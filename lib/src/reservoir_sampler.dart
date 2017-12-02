
import 'dart:math';

/// more efficient mechanism to pick K thing from N items. particularly if
/// the collection is large, or if the total # of items unknown, or if
/// the collection has inefficient length/elementAt. should be O(N).
///
/// algorithm here https://en.wikipedia.org/wiki/Reservoir_sampling
class ReservoirSampler {
  Random _random;

  ReservoirSampler([Random r]) {
    _random = r ?? new Random.secure();
  }

  List<T> pickN<T>(Iterable<T> items, int k) {
    if (items == null) throw new ArgumentError("items may not be null!");

    var reservoir = new List(k); // new list of length k

    var ind = 0;
    var it = items.iterator;
    while (it.moveNext()) {
      if (ind < k) {
        // first K items, just add to reservoir
        reservoir.add(it.current);
      } else {
        // pick random index from 0 to ind
        int j = _random.nextInt(ind + 1);
        // if randomly picked index is smaller than k,
        // then replace the element present at the index
        // with new element from iterable
        if (j < k) {
          reservoir[j] = it.current;
        }
      }
      ind++;
    }
    return reservoir;
  }
}