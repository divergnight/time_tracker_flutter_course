import 'dart:ui';

import 'package:meta/meta.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.jobId,
    @required this.start,
    @required this.end,
    this.comment,
  });
  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String jobId = data['jobId'];
    final int startMilliseconds = data['start'];
    final int endMilliseconds = data['end'];
    if (startMilliseconds == null || endMilliseconds == null) return null;
    final String comment = data['comment'];
    return Entry(
      id: documentId,
      jobId: jobId,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: comment,
    );
  }

  Map<String, dynamic> toMap() {
    if (jobId == null || start == null || end == null) return null;
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  @override
  int get hashCode => hashValues(id, jobId, start, end, comment);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Entry otherEntry = other;
    return id == otherEntry.id &&
        jobId == otherEntry.jobId &&
        start == otherEntry.start &&
        end == otherEntry.end &&
        comment == otherEntry.comment;
  }

  @override
  String toString() =>
      'id: $id, jobId: $jobId, start: $start, end: $end, comment: $comment';
}
