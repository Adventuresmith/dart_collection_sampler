import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_collection_sampler/dart_collection_sampler.dart';

void main(List<String> arguments) {
  final argParser = ArgParser()
    ..addOption(
      "num",
      abbr: "n",
      help: "items to pick from rest of command line",
      defaultsTo: "1",
    )
    ..addFlag(
      "unique",
      abbr: "u",
      help: "select unique results",
      negatable: false,
    );

  final results = argParser.parse(arguments);

  exit(
    deal(
      int.parse(results["num"] as String),
      results.rest,
      unique: results['unique'] as bool,
    ),
  );
}

int deal(int n, List<String> items, {required bool unique}) {
  if (items.isEmpty) {
    stderr.writeln("you must supply one or more items as input");
    return 1;
  }
  stdout.writeln("Picking $n from $items (unique: $unique)\n");

  if (n == 1) {
    stdout.writeln("Selected item: ${CollectionSampler().pick(items)}");
  } else {
    stdout.writeln(
      "Selected items: ${CollectionSampler().pickN(items, n, unique: unique)}",
    );
  }
  return 0;
}
