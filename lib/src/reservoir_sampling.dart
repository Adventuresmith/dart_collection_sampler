import 'dart:math';

/// Picks N unique elements from an Iterable using reservoir sampling. should be O(N).
///
/// 'unique' meaning no single position will be selected more than once. If the
/// incoming collection has repeated values, then you may have repeated values in
/// the sample.
///
/// The basic algorithm is described here https://en.wikipedia.org/wiki/Reservoir_sampling
///
/// One change in this implementation is shuffling the results before returning.
/// If the sample is relatively big compared to the # of items, then
/// order within the sample is almost identical to the original list --
/// by shuffling the result the result will look less ordered.
///
/// for example,
/// ```
///    picking 5 items from [1,2,3,4,5,6,7,8,9]
///    could end up like    [1,6,3,4,5]
/// ```
///
List<T> reservoirSampling<T>(Iterable<T> items, int N, Random random) {
  final List<T> reservoir = List<T>.filled(N, items.first);

  var ind = 0;
  final it = items.iterator;
  // first N items, just add to reservoir
  while (it.moveNext() && ind < N) {
    reservoir[ind] = it.current;
    ind++;
  }
  while (it.moveNext()) {
    // pick random index from 0 to ind
    final j = random.nextInt(ind + 1);
    // if randomly picked index is smaller than N,
    // then replace the element present at the index
    // with new element from iterable
    if (j < N) {
      reservoir[j] = it.current;
    }
    ind++;
  }
  // if N is relatively 'big' compared to the size of the collection, then
  // the items are practically in-order as they are in the list.
  reservoir.shuffle(random);
  return reservoir;
}
