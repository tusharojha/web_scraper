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

Note that as of version **0.0.6**, the project supports not only Flutter projects, but also Dart projects.

## Implementation

```dart
    final webScraper = WebScraper('https://webscraper.io');
    if (await webScraper.loadWebPage('/test-sites/e-commerce/allinone')) {
      // Reference page: https://webscraper.io/test-sites/e-commerce/allinone

        // This will scrape the product names and links on the bottom row with 3 products.
        // Since they are randomized at every GET request, your results should change often.
        List<Map<String, dynamic>> elements = webScraper.getElement('div.row > div > div > div.caption > h4 > a', ['href']);
        print(elements); // Returns a List of Map<String, dynamic> items.
        // elements = [
        // {'title': stringWithProduct1Name, 'attributes': {'href': stringWithProduct1Link}},
        // {'title': stringWithProduct2Name, 'attributes': {'href': stringWithProduct2Link}},
        // {'title': stringWithProduct3Name, 'attributes': {'href': stringWithProduct3Link}},
        // ]

        // This will scrape the page h1 element: "E-commerce training site"
        List<String> titles = webScraper.getElementTitle('div.jumbotron > h1');
        print(titles); // Returns a List of Strings.
        // titles = ['E-commerce training site']

        // This will scrape the "Home" button's href attribute on the left side.
        List<String> attributes = webScraper.getElementAttribute('#side-menu > li.active > a', 'href');
        print(attributes); // Returns a List of Strings.
        // attributes = ['/test-sites/e-commerce/allinone']
    }
```

Checkout [`web_scraper_test.dart`](/test/web_scraper_test.dart) file to have closer look on all functionalities.

## Methods

| Method | Description | Arguments | Return Type
|---|---|---|---|
| loadWebPage | Loads the webpage into response object | String route | Future `<bool>` |
| getPageContent | Returns webpage's html in string format | Void | String body |
| getElement | Returns List of elements found at specified address | String address, List `<String>` attributes | List `<Map<String, dynamic>>` |
| getElementTitle | Returns List of element titles found at specified address | String address | List `<String>` |
| getElementAttribute | Returns List of elements single attribute found at specified address (if you wish to get multiple attributes at once, please use `getElement` instead) | String address, List `<String>` attributes | List `<String>` |
| getAllScripts | Returns the list of all data enclosed in script tags of the document | Void | List `<String>` |
| getScriptVariables | Returns Map between given variable names and list of their occurence in the script tags | List `<String>` variableNames | Map `<String, dynamic>` |

## Contributing

- Please branch from _develop_ to implement bug fix/new feature.
- Ensure that code is formatted according to base dart rules & using the latest stable version of dart.
- Open a PR with _develop_ as the PR target with a clear description.
