import 'package:test/test.dart';
import 'package:web_scraper/validation.dart';

void main() {
  test('Error: use [http/https] protocol', () {
    var val = Validation().isBaseURL("htp://google.com");
    expect(val.Is, false);
    expect(val.Description, "use [http/https] protocol");
  });

  test(
      'Error: bring url to the format scheme:[//]domain; EXAMPLE: https://google.com',
      () {
    var val = Validation().isBaseURL("http:/google.com");
    expect(val.Is, false);
    expect(val.Description,
        "bring url to the format scheme:[//]domain; EXAMPLE: https://google.com");
  });

  test('Error: URL should contain only domain without path', () {
    var val = Validation().isBaseURL("http://google.com/q");
    expect(val.Is, false);
    expect(val.Description, "URL should contain only domain without path");
  });
  test(
      'Remove unnecessary slash and Error: URL should contain only domain without path',
      () {
    var val = Validation().isBaseURL("http://google.com///q/b//f");
    expect(val.Is, false);
    expect(val.Description, "URL should contain only domain without path");
  });

  test('Sucess validate url', () {
    var val = Validation().isBaseURL("http://google.com");
    expect(val.Is, true);
    expect(val.Description, "ok");
  });
  test('Sucess validate url and remove unnecessary slash', () {
    var val = Validation().isBaseURL("http://google.com///////////////");
    expect(val.Is, true);
    expect(val.Description, "ok");
  });
}
