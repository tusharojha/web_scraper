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

Checkout [`web_scraper_test.dart`](/test/web_scraper_test.dart) file to have closer look on all functionalities.

## Methods

| Method | Description | Arguments | Return Type
|---|---|---|---|
| loadWebPage | Loads the webpage into response object | String route | Future `<bool>` |
| getPageContent | Returns webpage's html in string format | Void | String body |
| getElement | Returns List of elements found at specified address | String address, List `<String>` attributes | List `<Map<String, dynamic>>` |
| getAllScripts | Returns the list of all data enclosed in script tags of the document | Void | List `<String>` |
| getScriptVariables | Returns Map between given variable names and list of their occurence in the script tags | List `<String>` variableNames | Map `<String, dynamic>` |

## Contribute to the package at GitHub.
- File bugs, features, etc.
- Fix bugs and send pull requests
- Review pull requests
