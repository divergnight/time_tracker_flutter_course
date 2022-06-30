import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final job = Job.fromMap(null, 'abc');
      expect(job, null);
    });
    test('job with all properties', () {
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(job, Job(name: 'Blogging', ratePerHour: 10, id: 'abc'));
    });

    test('missing ratePerHour', () {
      final job = Job.fromMap({
        'name': 'Blogging',
      }, 'abc');
      expect(job, Job(name: 'Blogging', ratePerHour: 0, id: 'abc'));
    });

    test('missing id', () {
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, null);
      expect(job, Job(name: 'Blogging', ratePerHour: 10, id: null));
    });

    test('missing name', () {
      final job = Job.fromMap({
        'ratePerHour': 10,
      }, 'abc');
      expect(job, null);
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });

    test('invalid name', () {
      final job = Job(name: null, ratePerHour: 10, id: 'abc');
      expect(job.toMap(), null);
    });

    test('invalid ratePerHour', () {
      final job = Job(name: 'Blogging', ratePerHour: null, id: 'abc');
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 0,
      });
    });

    test('invalid id', () {
      final job = Job(name: 'Blogging', ratePerHour: 10, id: null);
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}
