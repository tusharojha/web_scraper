[![Pub](https://img.shields.io/pub/v/web_scraper.svg)](https://pub.dev/packages/web_scraper)

# A Simple Web Scraper for Dart & Flutter

A very basic web scraper implementation to scrap html elements from a web page.

Pull requests are most welcome.

## Getting Started

In your `pubspec.yaml` root add:

```yaml
dependencies:
  web_scraper:
```

then,

```dart
import 'package:web_scraper/web_scraper.dart';
```

Note that as of version 0.0.6, the project supports not only Flutter projects, but also Dart projects.

## Implementation

```dart
    final webScraper = WebScraper('https://webscraper.io');
    if (await webScraper.loadWebPage('/test-sites/e-commerce/allinone')) {
        List<Map<String, dynamic>> elements = webScraper.getElement('h3.title > a.caption', ['href']);
        print(elements);
    }
```

Checkout [`web_scraper_test.dart`](/test/web_scraper_test.dart) file to have closer look on all functionalities.

## Methods

| Method | Description | Arguments | Return Type
|---|---|---|---|
| loadWebPage | Loads the webpage into response object | String route | Future `<bool>` |
| getPageContent | Returns webpage's html in string format | Void | String body |
| getElement | Returns List of elements found at specified address | String address, List `<String>` attributes | List `<Map<String, dynamic>>` |
| getAllScripts | Returns the list of all data enclosed in script tags of the document | Void | List `<String>` |
| getScriptVariables | Returns Map between given variable names and list of their occurence in the script tags | List `<String>` variableNames | Map `<String, dynamic>` |

## Contributing

- Please branch from _develop_ to implement bug fix/new feature.
- Ensure that code is formatted according to base dart rules.
- Open a PR with _develop_ as the PR target with a clear description.
