import 'package:test/test.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  final webScraper = WebScraper('https://webscraper.io');

  group('Complete Web Scraper Test', () {
    bool page;
    var productNames = <Map<String, dynamic>>[];
    test('Loads Webpage Route', () async {
      page = await webScraper.loadWebPage('/test-sites/e-commerce/allinone');
      expect(page, true);
    });
    test('Loads Full URL', () async {
      expect(
          await WebScraper().loadFullURL(
              'https://webscraper.io/test-sites/e-commerce/allinone'),
          true);
    });
    test('Gets Page Content & Loads from String', () {
      final pageContent = webScraper.getPageContent();
      expect(pageContent, isA<String>());
    });
    test('Elapsed Time', () {
      // time elapsed is integral value (in milliseconds)
      var timeElapsed = webScraper.timeElaspsed;
      print('Elapsed Time(in Milliseconds): ' + timeElapsed.toString());
      expect(timeElapsed, isNotNull);
    });

    test('Get Element Title', () {
      var names = webScraper
          .getElementTitle('div.thumbnail > div.caption > h4 > a.title');
      expect(names, isNotEmpty);
    });

    test('Get Element Attribute', () {
      var names = webScraper.getElementAttribute(
          'div.thumbnail > div.caption > h4 > a.title', 'title');
      expect(names, isNotEmpty);
    });

    test('Get Elements by selector', () async {
      productNames = webScraper.getElement(
        'div.thumbnail > div.caption > h4 > a.title',
        ['href', 'title'],
      );
      expect(productNames, isNotNull);
    });
    test('Fetching All Scripts', () {
      var scripts = webScraper.getAllScripts();
      print('List of all script tags: ');
      print(scripts);
      expect(scripts, isNotNull);
    });
    test('Fetching Script variables', () {
      var variables = webScraper.getScriptVariables(['j.async']);
      print('List of all variable occurences: ');
      print(variables);
      expect(variables, isNotNull);
    });
  });
}
