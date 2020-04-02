/*
  Developed by Tushar Ojha
  GitHub: https://github.com/tusharojha
  Twitter: https://twitter.com/tusharojha
  Feel free to improve the web_scraper library.
*/

library web_scraper;

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements
import 'dart:async';

/// WebScraper Main Class
class WebScraper {
  // Response Object of web scrapping the website
  var _response;

  // time elapsed in loading in milliseconds
  int timeElaspsed;

  // base url of the website to be scrapped
  String baseUrl;

  /// Creates the web scraper instance
  WebScraper(String baseUrl) {
    if (baseUrl == '' || baseUrl == null)
      throw WebScraperException(
          "Base Url cannot be empty inside the constructor");
    this.baseUrl = baseUrl;
  }

  /// Loads the webpage into response object
  Future<bool> loadWebPage(String route) async {
    if (baseUrl != null || baseUrl != '') {
      final stopwatch = Stopwatch()..start();
      var client = Client();
      try {
        _response = await client.get(baseUrl + route);
        // Calculating Time Elapsed using timer from dart:core
        if (_response != null) {
          timeElaspsed = stopwatch.elapsed.inMilliseconds;
          stopwatch.stop();
          stopwatch.reset();
        }
      } catch (e) {
        throw WebScraperException(e.message);
      }
      return true;
    }
    return false;
  }

  /// Returns webpage's html in string format
  String getPageContent() => _response != null
      ? _response.body.toString()
      : "ERROR: Webpage need to be loaded first, try calling loadWebPage";

  /// Returns List of elements found at specified address
  /// example address: "div.item > a.title" where item and title are class names of div and a tag respectively.
  List<Map<String, dynamic>> getElement(String address, List<String> attribs) {
    // attribs are the list of attributes required to extract from the html tag(s) ex. ['href', 'title']
    if (_response == null)
      throw WebScraperException(
          "getElement cannot be called before loadWebPage");
    // Using html parser and query selector to get a list of particular element
    var document = parse(_response.body);
    List<Element> elements = document.querySelectorAll(address);
    List<Map<String, dynamic>> elementData = [];

    for (var element in elements) {
      Map<String, dynamic> attribData = new Map<String, dynamic>();
      for (String attrib in attribs) {
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

/// WebScraperException throws exception with specified message
class WebScraperException implements Exception {
  var _message;
  WebScraperException(String message) {
    this._message = message;
  }
  String errorMessage() {
    return _message;
  }
}
