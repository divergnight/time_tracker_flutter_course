import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry_list_tile_model.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class EntryListTile extends StatelessWidget {
  const EntryListTile(
      {@required this.tileModel, @required this.job, @required this.onTap});
  final EntryListTileModel tileModel;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final valueFormatted = tileModel.format();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(valueFormatted['dayOfWeek'],
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(valueFormatted['startDate'], style: TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              valueFormatted['pay'],
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('${valueFormatted['startTime']} - ${valueFormatted['endTime']}',
              style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(valueFormatted['duration'], style: TextStyle(fontSize: 16.0)),
        ]),
        if (valueFormatted['comment'].isNotEmpty)
          Text(
            valueFormatted['comment'],
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}
