import 'package:bckgrnd/ppln/ppln_segment_status.dart';
import 'package:bckgrnd/ppln/record/record_status.dart';
import 'package:isar/isar.dart';

part 'ppln_segment_status_g.g.dart';

@collection
class PplnSegmentStatusG {
  PplnSegmentStatusG(this.pplnSegmentStatus);

  int get id => pplnSegmentStatus.id;

  final PplnSegmentStatus pplnSegmentStatus;
}
