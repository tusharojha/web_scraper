import 'package:test/test.dart';
import 'package:web_scraper/src/validation.dart';

void main() {
  test('Error: use [http/https] protocol', () {
    var val = Validation().isBaseURL('htp://google.com');
    expect(val.isCorrect, false);
    expect(val.description, 'use [http/https] protocol');
  });

  test(
      'Error: bring url to the format scheme:[//]domain; EXAMPLE: https://google.com',
      () {
    var val = Validation().isBaseURL('http:/google.com');
    expect(val.isCorrect, false);
    expect(val.description,
        'bring url to the format scheme:[//]domain; EXAMPLE: https://google.com');
  });

  test('Error: URL should contain only domain without path', () {
    var val = Validation().isBaseURL('http://google.com/q');
    expect(val.isCorrect, false);
    expect(val.description, 'URL should contain only domain without path');
  });
  test(
      'Remove unnecessary slash and Error: URL should contain only domain without path',
      () {
    var val = Validation().isBaseURL('http://google.com///q/b//f');
    expect(val.isCorrect, false);
    expect(val.description, 'URL should contain only domain without path');
  });

  test('Sucess validate url', () {
    var val = Validation().isBaseURL('http://google.com');
    expect(val.isCorrect, true);
    expect(val.description, 'ok');
  });
  test('Sucess validate url and remove unnecessary slash', () {
    var val = Validation().isBaseURL('http://google.com///////////////');
    expect(val.isCorrect, true);
    expect(val.description, 'ok');
  });
}
