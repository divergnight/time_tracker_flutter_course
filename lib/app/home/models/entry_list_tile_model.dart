import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class EntryListTileModel {
  EntryListTileModel(this.context, {@required this.entry, @required this.job});
  BuildContext context;
  Entry entry;
  Job job;

  Map<String, String> format() {
    final pay = job.ratePerHour * entry.durationInHours;
    return {
      'dayOfWeek': Provider.of<Format>(context).dayOfWeek(entry.start),
      'startDate': Provider.of<Format>(context).date(entry.start),
      'startTime': TimeOfDay.fromDateTime(entry.start).format(context),
      'endTime': TimeOfDay.fromDateTime(entry.end).format(context),
      'duration': Provider.of<Format>(context).hours(entry.durationInHours),
      'pay': Provider.of<Format>(context).currency(pay),
      'comment': entry.comment,
    };
  }
}
