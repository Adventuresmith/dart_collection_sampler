# dart_collection_sampler
[![Pub Package](https://img.shields.io/pub/v/dart_collection_sampler.svg)](https://pub.dartlang.org/packages/dart_collection_sampler)
[![Dart](https://github.com/Adventuresmith/dart_collection_sampler/actions/workflows/dart.yml/badge.svg)](https://github.com/Adventuresmith/dart_collection_sampler/actions/workflows/dart.yml)
[![codecov](https://codecov.io/gh/Adventuresmith/dart_collection_sampler/branch/master/graph/badge.svg?token=77209PUWLS)](https://codecov.io/gh/Adventuresmith/dart_collection_sampler)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)


a small library implementing methods to sample items from collections

## Usage

A simple usage example:

```dart

void deal(int n, List<String> items, {required bool unique}) {
  stdout.writeln("Picking $n from $items (unique: $unique)\n");

  if (n == 1) {
    stdout.writeln("Selected item: ${CollectionSampler().pick(items)}");
  } else {
    stdout.writeln(
      "Selected items: ${CollectionSampler().pickN(items, n, unique: unique)}",
    );
  }
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Adventuresmith/dart_collection_sampler/issues
