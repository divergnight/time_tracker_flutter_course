import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final entry = Entry.fromMap(null, 'abc');
      expect(entry, null);
    });
    test('entry with all properties', () {
      final entry = Entry.fromMap({
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': 'test',
      }, '123');
      expect(
          entry,
          Entry(
              id: '123',
              jobId: 'abc',
              start: DateTime(2019, 08, 12, 22, 40),
              end: DateTime(2019, 08, 13, 01, 40),
              comment: 'test'));
    });

    test('missing id', () {
      final entry = Entry.fromMap({
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': 'test',
      }, null);
      expect(
          entry,
          Entry(
              id: null,
              jobId: 'abc',
              start: DateTime(2019, 08, 12, 22, 40),
              end: DateTime(2019, 08, 13, 01, 40),
              comment: 'test'));
    });
    test('missing jobId', () {
      final entry = Entry.fromMap({
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': 'test',
      }, '123');
      expect(
          entry,
          Entry(
              id: '123',
              jobId: null,
              start: DateTime(2019, 08, 12, 22, 40),
              end: DateTime(2019, 08, 13, 01, 40),
              comment: 'test'));
    });

    test('missing start', () {
      final entry = Entry.fromMap({
        'jobId': 'abc',
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': 'test',
      }, '123');
      expect(entry, null);
    });

    test('missing end', () {
      final entry = Entry.fromMap({
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'comment': 'test',
      }, '123');
      expect(entry, null);
    });

    test('missing comment', () {
      final entry = Entry.fromMap({
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
      }, '123');
      expect(
          entry,
          Entry(
              id: '123',
              jobId: 'abc',
              start: DateTime(2019, 08, 12, 22, 40),
              end: DateTime(2019, 08, 13, 01, 40),
              comment: null));
    });
  });

  group('toMap', () {
    test('valid start, end', () {
      final entry = Entry(
          id: '123',
          jobId: 'abc',
          start: DateTime(2019, 08, 12, 22, 40),
          end: DateTime(2019, 08, 13, 01, 40),
          comment: 'test');
      expect(entry.toMap(), {
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': 'test',
      });
    });

    test('invalid id', () {
      final entry = Entry(
          id: '123',
          jobId: 'abc',
          start: DateTime(2019, 08, 12, 22, 40),
          end: DateTime(2019, 08, 13, 01, 40),
          comment: 'test');
      expect(entry.toMap(), {
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': 'test',
      });
    });
    test('invalid jobId', () {
      final entry = Entry(
          id: '123',
          jobId: null,
          start: DateTime(2019, 08, 12, 22, 40),
          end: DateTime(2019, 08, 13, 01, 40),
          comment: 'test');
      expect(entry.toMap(), null);
    });
    test('invalid start', () {
      final entry = Entry(
          id: '123',
          jobId: 'abc',
          start: null,
          end: DateTime(2019, 08, 13, 01, 40),
          comment: 'test');
      expect(entry.toMap(), null);
    });
    test('invalid end', () {
      final entry = Entry(
          id: '123',
          jobId: 'abc',
          start: DateTime(2019, 08, 12, 22, 40),
          end: null,
          comment: 'test');
      expect(entry.toMap(), null);
    });
    test('missing comment', () {
      final entry = Entry(
        id: '123',
        jobId: 'abc',
        start: DateTime(2019, 08, 12, 22, 40),
        end: DateTime(2019, 08, 13, 01, 40),
      );
      expect(entry.toMap(), {
        'jobId': 'abc',
        'start': DateTime(2019, 08, 12, 22, 40).millisecondsSinceEpoch,
        'end': DateTime(2019, 08, 13, 01, 40).millisecondsSinceEpoch,
        'comment': null,
      });
    });
  });
}
