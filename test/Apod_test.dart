import 'package:flutter_test/flutter_test.dart';
import 'package:lists/Apod.dart';

void main() {
  group('Apod unit tests', () {
    {
      test('Should create Apod with null title', () {
        Apod apod = Apod();

        expect(apod.title, null);
      });
      test('Should create Apod with null title', () {
        Apod apod = Apod();
        apod.title = 'Mars';

        expect(apod.title, 'Mars');
      });
    }
  });
}
