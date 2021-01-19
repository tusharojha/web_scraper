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
    // loadWebPage is an asynchronous method, so it needs to be placed inside an async function.
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

    // Alternatively, you can provide the URL in a single string with loadFromURL(). Since you are going this route, you can just skip providing a base URL to the WebScraper class constructor.
    WebScraper simpleLoader = WebScraper();
    // loadFromURL also is an asynchronous method, so it also needs to be placed inside an async function.
    // This will either return a true bool if it loads successfully or throw an error if it doesn't.
    if (await simpleLoader.loadFromURL('https://webscraper.io/test-sites/e-commerce/allinone') {
      // After it loads, you can use any of the getElement methods just as you normally would.
      List<Map<String, dynamic>> elements = simpleLoader.getElement('div.row > div > div > div.caption > h4 > a', ['href']);
      print(elements);

      List<String> titles = simpleLoader.getElementTitle('div.jumbotron > h1');
      print(titles);

      List<String> attributes = simpleLoader.getElementAttribute('#side-menu > li.active > a', 'href');
      print(attributes);
    }

    // If you want to use compute functions to optmize performance and avoid application jank, there are helper methods for that.
    WebScraper saveToString = WebScraper();
    String stringBody;
    if (await saveToString.loadFromURL('https://www.google.com/')) {
      stringBody = stringLoader.getPageContent();
    }

    Map<String, String> yourComputeFunction(String stringBody) {
      Map<String, String> yourMapOfData;
      WebScraper stringLoader = WebScraper();
      // loadFromString is synchronous.
      stringLoader.loadFromString(stringBody)
      // Perform your query operations here.
      return yourMapOfData;
    }

    Map<String, String> dataYouNeed = compute(yourComputeFunction, stringBody);
```

Checkout [`web_scraper_test.dart`](/test/web_scraper_test.dart) file to have closer look on all functionalities.

## Methods

| Method | Description | Arguments | Return Type
|---|---|---|---|
| loadWebPage | Loads the webpage into response object and then parse it into the document object | String route | Future `<bool>` |
| loadFromURL | Loads the webpage from provided URL into response object and then parse it into the document object | String page | Future `<bool>` |
| loadFromString | Loads the webpage from a String (usually stored by the `getPageContent` method) into response object and then parse it into the document object. This operation is completely synchronous and exists as a helper method to perform `compute()` flutter operations and avoid jank | String responseBodyAsString | Future `<bool>` |
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
