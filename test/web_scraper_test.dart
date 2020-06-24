import 'package:test/test.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  final webScraper = WebScraper('https://webscraper.io');

  group('Complete Web Scraper Test', () {
    bool page;
    List<Map<String, dynamic>> productNames = [];
    test('Loads Webpage', () async {
      page = await webScraper.loadWebPage('/test-sites/e-commerce/allinone');
      expect(page, true);
    });
    test('Elapsed Time', () {
      // time elapsed is integral value (in milliseconds)
      int timeElapsed = webScraper.timeElaspsed;
      print("Elapsed Time(in Milliseconds): " + timeElapsed.toString());
      expect(timeElapsed, isNotNull);
    });
    test('Parse tags', () async {
      productNames = webScraper.getElement(
        'div.thumbnail > div.caption > h4 > a.title',
        ['href', 'title'],
      );
      expect(productNames, isNotNull);
    });
    test('Fetching All Scripts', () {
      List<String> scripts = webScraper.getAllScripts();
      print("List of all script tags: ");
      print(scripts);
      expect(scripts, isNotNull);
    });
    test('Fetching Script variables', () {
      Map<String, List<String>> variables =
          webScraper.getScriptVariables(['j.async']);
      print("List of all variable occurences: ");
      print(variables);
      expect(variables, isNotNull);
    });
  });
}
