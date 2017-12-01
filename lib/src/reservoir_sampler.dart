
import 'dart:math';

/// algorithm here https://en.wikipedia.org/wiki/Reservoir_sampling
class ReservoirSampler {
  Random _random;

  ReservoirSampler([Random r]) {
    _random = r ?? new Random.secure();
  }

  /*
  // A function to randomly select k items from stream[0..n-1].
    static void selectKItems(int stream[], int n, int k)
    {
        int i;   // index for elements in stream[]

        // reservoir[] is the output array. Initialize it with
        // first k elements from stream[]
        int reservoir[] = new int[k];
        for (i = 0; i < k; i++)
            reservoir[i] = stream[i];

        Random r = new Random();

        // Iterate from the (k+1)th element to nth element
        for (; i < n; i++)
        {
            // Pick a random index from 0 to i.
            int j = r.nextInt(i + 1);

            // If the randomly  picked index is smaller than k,
            // then replace the element present at the index
            // with new element from stream
            if(j < k)
                reservoir[j] = stream[i];
        }

        System.out.println("Following are k randomly selected items");
        System.out.println(Arrays.toString(reservoir));
    }
   */
  T pickN<T>(Iterable<T> items) {
    if (items == null) throw new ArgumentError("items may not be null!");
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = _random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }
}