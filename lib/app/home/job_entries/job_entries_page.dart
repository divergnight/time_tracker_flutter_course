import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/entry_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/edit_entry_page.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry_list_tile_model.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => JobEntriesPage(database: database, job: job),
        fullscreenDialog: false,
      ),
    );
  }

  Future<void> _delete(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              title: Text(jobName),
              centerTitle: true,
              elevation: 2.0,
              actions: <Widget>[
                IconButton(
                  onPressed: () =>
                      EditJobPage.show(context, database: database, job: job),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () =>
                      EditEntryPage.show(context, database: database, job: job),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            body: _buildContent(context),
          );
        });
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: ((context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) => Dismissible(
            key: Key('entry-${entry.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, entry),
            child: EntryListTile(
              job: job,
              tileModel: EntryListTileModel(context, entry: entry, job: job),
              onTap: () => EditEntryPage.show(context,
                  database: database, job: job, entry: entry),
            ),
          ),
        );
      }),
    );
  }
}
