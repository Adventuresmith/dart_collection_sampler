# dart_collection_sampler
[![Pub Package](https://img.shields.io/pub/v/dart_collection_sampler.svg)](https://pub.dartlang.org/packages/dart_collection_sampler)


a small library implementing methods to sample items from collections

## Usage

A simple usage example:

```$dart
import 'package:args/args.dart';

import 'dart:io';
import 'package:dart_collection_sampler/dart_collection_sampler.dart';

main(List<String> arguments) {

  var argParser = ArgParser()
      ..addOption("num", abbr: "n", help: "items to pick from rest of command line", defaultsTo: "1");

  var results = argParser.parse(arguments);

  exit(
    roll(int.parse(results["num"]), results.rest)
  );
}

int roll(int n, List<String> items) {
  if (items.isEmpty) {
    print ("you must supply one or more items as input");
    return 1;
  }
  print ("Picking $n from $items\n");

  if (n == 1) {
    print ("Selected item: ${new CollectionSampler().pick(items)}");
  } else {
    print ("Selected items: ${new CollectionSampler().pickN(items, n)}");
  }
  return 0;
}


```


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/stevesea/dart_collection_sampler/issues
