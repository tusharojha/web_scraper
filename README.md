[![Pub](https://img.shields.io/pub/v/web_scraper.svg)](https://pub.dev/packages/web_scraper)
## A Simple Web Scraper for Dart & Flutter

A very basic web scraper implementation to scrap html elements from a web page.

Pull requests certainly welcome.


## Installation
In your `pubspec.yaml` root add:

```yaml
dependencies:
  web_scraper: LATEST_VERSION_NUMBER
```

then,

`import 'package:web_scraper/web_scraper.dart';`


## Implementation

```dart
    final webScraper = WebScraper('https://webscraper.io');
    if(await webScraper.loadWebPage('/test-sites/e-commerce/allinone')){
        List<Map<String, dynamic>> elements = webScraper.getElement('h3.title > a.caption', ['href']);
        print(elements);
    }

```

## Contribute to the package at GitHub.
- File bugs, features, etc.
- Fix bugs and send pull requests
- Review pull requests
