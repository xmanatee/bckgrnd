import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bckgrnd/ppln/ppln_segment_status.dart';

import 'package:bckgrnd/storage/ppln_segment_status_g.dart';

class Storage {
  Storage._();
  static final Storage instance = Storage._();

  late final Isar isar;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = Isar.open(
      schemas: [PplnSegmentStatusGSchema],
      directory: dir.path,
    );
  }

  Future<void> put(final PplnSegmentStatus pplnSegmentStatus) async {
    debugPrint(
        '[Storage] putting: ${pplnSegmentStatus.toPrettyJson().toString()}');
    await isar.writeAsync((final isar) {
      isar.pplnSegmentStatusGs.put(PplnSegmentStatusG(pplnSegmentStatus));
    });
  }

  Future<PplnSegmentStatus> get(final int id) async {
    debugPrint('[Storage] getting: $id');
    return (await isar.pplnSegmentStatusGs.getAsync(id))!.pplnSegmentStatus;
  }

  Stream<List<PplnSegmentStatus>> watch() {
    final query = isar.pplnSegmentStatusGs.where().sortByIdDesc().build();

    return query
        .watch(fireImmediately: true, limit: 10)
        // .where((final e) => e.isNotEmpty)
        .map((final l) => l.map((final e) => e.pplnSegmentStatus).toList());
  }
}
