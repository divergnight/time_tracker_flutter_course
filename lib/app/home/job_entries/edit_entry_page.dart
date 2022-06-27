import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditEntryPage extends StatefulWidget {
  const EditEntryPage(
      {Key key, @required this.database, @required this.job, this.entry})
      : super(key: key);
  final Database database;
  final Job job;
  final Entry entry;

  static Future<void> show(BuildContext context,
      {Database database, Job job, Entry entry}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          EditEntryPage(database: database, job: job, entry: entry),
      fullscreenDialog: true,
    ));
  }

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  bool isLoading = false;
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _comment;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      jobId: widget.job.id,
      start: start,
      end: end,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.entry == null ? 'Create' : 'Update'),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading ? null : () => _setEntryAndDismiss(context),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.indigo[600],
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildStartDate(),
            _buildEndDate(),
            SizedBox(height: 8.0),
            _buildDuration(),
            SizedBox(height: 8.0),
            _buildComment(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    // TODO : DateTimePicker
  }

  Widget _buildEndDate() {
    // TODO : DateTimePicker
  }

  Widget _buildDuration() {
    // TODO : FormatTime
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
