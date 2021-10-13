/*
  Developed by Tushar Ojha
  GitHub: https://github.com/tusharojha
  Twitter: https://twitter.com/tusharojha
  Feel free to improve the web_scraper library.
*/

library web_scraper;

import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object.
import 'package:http/http.dart'; // Contains a client for making API calls.

import 'validation.dart';

/// WebScraper Main Class.
class WebScraper {
  // Response Object of web scrapping the website.
  var _response;

  // Parsed document from the response
  var _document;

  // Time elapsed in loading in milliseconds.
  int timeElaspsed;

  // Base url of the website to be scrapped.
  String baseUrl;

  Map<int, Client> Clients;

  /// Creates the web scraper instance.
  WebScraper([String baseUrl]) {
    if (baseUrl != null) {
      var v = Validation().isBaseURL(baseUrl);
      if (!v.isCorrect) {
        throw WebScraperException(v.description);
      }
      this.baseUrl = baseUrl;
    }
  }

  /// Loads the webpage into response object.
  Future<bool> loadWebPage(String route) async {
    if (baseUrl != null && baseUrl != '') {
      // final stopwatch = Stopwatch()..start();
      var client = Client();

      try {
        _response = await client.get(baseUrl + route);
        // Calculating Time Elapsed using timer from dart:core.
        if (_response != null) {
          // timeElaspsed = stopwatch.elapsed.inMilliseconds;
          // stopwatch.stop();
          // stopwatch.reset();
          _document = parse(_response.body);
        }
      } catch (e) {
        throw WebScraperException(e.message);
      }
      return true;
    }
    return false;
  }

  /// This is a helper function in case you need to retrieve additional content of a webpage that has infinite scrolling.
  /// Sniff the network request sent and replicate using this if it's a [POST request], hence the method name.
  /// For [GET request]s, you should be able to use [loadWebPage] or [loadFullURL] instead.
  /// If your response is a partial HTML body, parse it using [loadFragment] instead of [loadFromString] and [loadWebPage], as those will not work as intended.
  ///
  /// This function takes 1 obligatory parameter [route] which can be provided as [String] or [URI] and 3 optional named parameters: [headers], [body] and [encoding].
  /// [headers] takes a [Map<String, String>], [body] can take a [String], a [List] or a [Map<String, String>] and [encoding] takes an [Encoding] class object.
  /// Please check out the [http] library [post] method if you need additional information on these parameters.
  ///
  /// If you need help sniffing network requests in order to provide the proper parameters to this method, it's recommended to use the [Postman] application with the appropriate extensions to your browser.
  /// All of this was tested using the standalone program with the [Postman Interceptor] extension for [Google Chrome].
  Future<dynamic> poster(dynamic route,
      {Map<String, String> headers, dynamic body, Encoding encoding}) async {
    try {
      _response = await Client()
          .post(route, body: body, headers: headers, encoding: encoding);

      if (_response.statusCode == 200) {
        return json.decode(_response.body);
      }
      throw Error;
    } catch (e) {
      throw WebScraperException(e.message);
    }
  }

  /// Loads the webpage URL into response object without requiring the two-step process of base + route.
  /// Unlike the the two-step process, the URL is NOT validated before being requested.
  Future<bool> loadFullURL(String page) async {
    var client = Client();
    try {
      _response = await client.get(page);
      // Calculating Time Elapsed using timer from dart:core.
      if (_response != null) {
        // Parses the response body once it's retrieved to be used on the other methods.
        _document = parse(_response.body);
      }
    } catch (e) {
      throw WebScraperException(
          "Error loading the provided URL: $page.\n" + e.message);
    }
    return true;
  }

  /// Loads a webpage that was previously loaded and stored as a String by using [getPageContent()].
  /// This exists as a helper function in order to facilitate the use of [compute()] functions in your Flutter apps.
  /// This operation is synchronous and returns a [true] bool once the string has been loaded and is ready to
  /// be queried by either [getElement()], [getElementTitle] or [getElementAttribute].
  bool loadFromString(String responseBodyAsString) {
    try {
      // Parses the response body once it's retrieved to be used on the other methods.
      _document = parse(responseBodyAsString);
    } catch (e) {
      throw WebScraperException(e.message);
    }
    return true;
  }

  /// Loads a fragmented webpage that was previously loaded and stored as a String by parsing another network request.body as [String].
  /// This exists as a helper function in order to facilitate the use of [compute()] functions in your Flutter apps.
  /// This operation is synchronous and returns a [true] bool once the string has been loaded and is ready to
  /// be queried by either [getElement()], [getElementTitle] or [getElementAttribute].
  bool loadFragment(String fragmentBodyAsString) {
    try {
      // Parses the response body once it's retrieved to be used on the other methods.
      _document = parseFragment(fragmentBodyAsString);
    } catch (e) {
      throw WebScraperException(e.message);
    }
    return true;
  }

  /// Returns the list of all data enclosed in script tags of the document.
  List<String> getAllScripts() {
    // The _response should not be null (loadWebPage must be called before getAllScripts).
    assert(_document != null,
        "You need to load a body before calling this method!");

    // Quering the list of elements by tag names.
    var scripts = _document.getElementsByTagName('script');
    var result = <String>[];

    // Looping in all script tags of the document.
    for (var script in scripts) {
      /// Adds the data enclosed in script tags
      /// ex. if document contains <script> var a = 3; </script>
      /// var a = 3; will be added to result.
      result.add(script.text);
    }
    return result;
  }

  /// Returns Map between given variable names and list of their occurence in the script tags
  /// ex. if document contains
  /// <script> var a = 15; var b = 10; </script>
  /// <script> var a = 9; </script>
  /// method will return {a: ['var a = 15;', 'var a = 9;'], b: ['var b = 10;'] }.
  Map<String, dynamic> getScriptVariables(List<String> variableNames) {
    // The _response should not be null (loadWebPage must be called before getScriptVariables).
    assert(_document != null,
        "You need to load a body before calling this method!");

    // Quering the list of elements by tag names.
    var scripts = _document.getElementsByTagName('script');

    var result = <String, List<String>>{};

    // Looping in all the script tags of the document.
    for (var script in scripts) {
      // Looping in all the variable names that are required to extract.
      for (var variableName in variableNames) {
        // regular expression to get the variable names
        var re = RegExp(
            '$variableName *=.*?;(?=([^\"\']*\"[^\"\']*\")*[^\"\']*\$)',
            multiLine: true);
        //  Iterate all matches
        Iterable matches = re.allMatches(script.text);
        matches.forEach((match) {
          if (match != null) {
            // list for all the occurence of the variable name
            var temp = result[variableName];
            if (result[variableName] == null) {
              temp = [];
            }
            temp.add(script.text.substring(match.start, match.end));
            result[variableName] = temp;
          }
        });
      }
    }

    // Returning final result i.e. Map of variable names with the list of their occurences.
    return result;
  }

  /// Returns webpage's html body in string format.
  String getPageContent() => _response != null
      ? _response.body.toString()
      : throw WebScraperException(
          'ERROR: Webpage need to be loaded first, try calling loadWebPage');

  /// Returns List of elements titles found at specified address.
  /// Example address: "div.item > a.title" where item and title are class names of div and a tag respectively.
  /// For ease of access, when using Chrome inspection tool, right click the item you want to copy, then click "Inspect" and at the console, right click the highlighted item, right click and then click "Copy > Copy selector" and provide as String address parameter to this method.
  List<String> getElementTitle(String address) {
    if (_document == null) {
      throw WebScraperException(
          'getElement cannot be called before loadWebPage');
    }
    // Using html parser and query selector to get a list of particular element.
    var elements = _document.querySelectorAll(address);
    // ignore: omit_local_variable_types
    List<String> elementData = [];

    for (var element in elements) {
      // Checks if the element's text is pure space before adding it to the list.
      if (element.text.trim() != '') {
        elementData.add(element.text);
      }
    }
    return elementData;
  }

  /// Returns List of elements' attributes found at specified address respecting the provided attribute requirement.
  /// Example address: "div.item > a.title" where item and title are class names of div and a tag respectively.
  /// For ease of access, when using Chrome inspection tool, right click the item you want to copy, then click "Inspect" and at the console, right click the highlighted item, right click and then click "Copy > Copy selector" and provide as String parameter to this method.
  /// Attributes are the bits of information between the HTML tags.
  /// Per example in <div class="strong and bold" style="width: 100%;" title="Fierce!">
  /// The element would be "div.strong.and.bold" and the possible attributes to fetch would be EIHER "style" OR "title" returning with EITHER of the values "width: 100%;" OR "Fierce!" respectively.
  /// To retrieve multiple attributes at once from a single element, please use getElement() instead.
  List<String> getElementAttribute(String address, String attrib) {
    // Attribs are the list of attributes required to extract from the html tag(s) ex. ['href', 'title'].
    if (_document == null) {
      throw WebScraperException(
          'getElement cannot be called before loadWebPage');
    }
    // Using html parser and query selector to get a list of particular element.
    var elements = _document.querySelectorAll(address);
    // ignore: omit_local_variable_types
    List<String> elementData = [];

    for (var element in elements) {
      var attribData = <String, dynamic>{};
      attribData[attrib] = element.attributes[attrib];
      // Checks if the element is empty before adding it to the list.
      if (attribData[attrib] != null) {
        elementData.add(attribData[attrib]);
      }
    }
    return elementData;
  }

  /// Returns List of elements found at specified address.
  /// Example address: "div.item > a.title" where item and title are class names of div and a tag respectively.
  List<Map<String, dynamic>> getElement(String address, List<String> attribs) {
    // Attribs are the list of attributes required to extract from the html tag(s) ex. ['href', 'title'].
    if (_document == null) {
      throw WebScraperException(
          'getElement cannot be called before loading a page!');
    }
    // Using html parser and query selector to get a list of particular element.
    var elements = _document.querySelectorAll(address);
    // ignore: omit_local_variable_types
    List<Map<String, dynamic>> elementData = [];

    for (var element in elements) {
      var attribData = <String, dynamic>{};
      for (var attrib in attribs) {
        attribData[attrib] = element.attributes[attrib];
      }
      elementData.add({
        'title': element.text,
        'attributes': attribData,
      });
    }
    return elementData;
  }
}

/// WebScraperException throws exception with specified message.
class WebScraperException implements Exception {
  var _message;
  WebScraperException(String message) {
    _message = message;
  }
  String errorMessage() {
    return _message;
  }
}
