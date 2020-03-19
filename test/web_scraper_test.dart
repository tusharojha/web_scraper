import 'package:flutter_test/flutter_test.dart';

import 'package:web_scraper/web_scraper.dart';

void main() {
  final webScraper = WebScraper('https://webscraper.io');
  test('Loads Webpage', () async{
    bool page = await webScraper.loadWebPage('/test-sites/e-commerce/allinone');
    expect(page, true);
  });
}
