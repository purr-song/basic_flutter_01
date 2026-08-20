import 'package:flutter_test/flutter_test.dart';
import 'package:seminar_utils/seminar_utils.dart';

void main() {
  test('formats a counter value', () {
    expect(SeminarFormatter.counterText(3), 'Count: 3');
  });
}
