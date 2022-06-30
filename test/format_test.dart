import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.singleton.hours(10), '10h');
    });
    test('zero', () {
      expect(Format.singleton.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.singleton.hours(-5), '0h');
    });
    test('decimal', () {
      expect(Format.singleton.hours(4.5), '4.5h');
    });
  });

  group('date - US Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_US';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2019-08-12', () {
      expect(Format.singleton.date(DateTime(2019, 08, 12)), 'Aug 12, 2019');
    });
    test('2019-08-16', () {
      expect(Format.singleton.date(DateTime(2019, 08, 16)), 'Aug 16, 2019');
    });
  });
}
