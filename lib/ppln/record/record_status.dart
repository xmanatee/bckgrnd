class RecordStatus {
  factory RecordStatus.fromJson(final Map<String, dynamic> json) {
    return RecordStatus(
      id: json['id'] as int,
      filePath: json['filePath'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      stopTime:
          json['stopTime'] != null ? DateTime.parse(json['stopTime']) : null,
      isSilent: json['isSilent'],
    );
  }

  factory RecordStatus.started(final String filePath) {
    return RecordStatus(
      id: ++lastId,
      filePath: filePath,
      startTime: DateTime.now(),
    );
  }

  RecordStatus({
    required this.id,
    required this.filePath,
    required this.startTime,
    this.stopTime,
    this.isSilent,
  });

  final int id;
  final String filePath;
  final DateTime startTime;
  final DateTime? stopTime;
  final bool? isSilent;

  Duration? get duration => stopTime?.difference(startTime);
  bool get finished => stopTime != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'startTime': startTime.toIso8601String(),
      'stopTime': stopTime?.toIso8601String(),
      'isSilent': isSilent,
    };
  }

  RecordStatus stopped({required final DateTime? silenceStartedTime}) =>
      RecordStatus(
        id: id,
        filePath: filePath,
        startTime: startTime,
        stopTime: DateTime.now(),
        isSilent: silenceStartedTime?.isBefore(startTime) ?? false,
      );

  RecordStatus mergeSilent(final RecordStatus other) {
    assert(isSilent! && other.isSilent!);
    return RecordStatus(
        id: id,
        filePath: filePath,
        startTime: startTime,
        stopTime: other.stopTime,
        isSilent: true);
  }

  static int lastId = 0;
}
