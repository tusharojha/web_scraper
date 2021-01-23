/*
  Developed by Tushar Ojha
  GitHub: https://github.com/tusharojha
  Twitter: https://twitter.com/tusharojha
  Feel free to improve the web_scraper library.
*/

library web_scraper;

import 'dart:async';

import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object.
import 'package:http/http.dart'; // Contains a client for making API calls.

import 'validation.dart';

/// WebScraper Main Class.
class WebScraper {
  // Response Object of web scrapping the website.
  var _response;

  // Time elapsed in loading in milliseconds.
  int timeElaspsed;

  // Base url of the website to be scrapped.
  String baseUrl;

  Map<int, Client> Clients;

  /// Creates the web scraper instance.
  WebScraper(String baseUrl) {
    var v = Validation().isBaseURL(baseUrl);
    if (!v.isCorrect) {
      throw WebScraperException(v.description);
    }
    this.baseUrl = baseUrl;
  }

  /// Loads the webpage into response object.
  Future<bool> loadWebPage(String route) async {
    if (baseUrl != null || baseUrl != '') {
      final stopwatch = Stopwatch()..start();
      var client = Client();

      try {
        _response = await client.get(baseUrl + route);
        // Calculating Time Elapsed using timer from dart:core.
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

  /// Returns the list of all data enclosed in script tags of the document.
  List<String> getAllScripts() {
    // The _response should not be null (loadWebPage must be called before getAllScripts).
    assert(_response != null);
    var document = parse(_response.body);

    // Quering the list of elements by tag names.
    var scripts = document.getElementsByTagName('script');
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
    assert(_response != null);
    var document = parse(_response.body);

    // Quering the list of elements by tag names.
    var scripts = document.getElementsByTagName('script');

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

  /// Returns webpage's html in string format.
  String getPageContent() => _response != null
      ? _response.body.toString()
      : throw WebScraperException(
          'ERROR: Webpage need to be loaded first, try calling loadWebPage');

  /// Returns List of elements found at specified address.
  /// Example address: "div.item > a.title" where item and title are class names of div and a tag respectively.
  List<Map<String, dynamic>> getElement(String address, List<String> attribs) {
    // Attribs are the list of attributes required to extract from the html tag(s) ex. ['href', 'title'].
    if (_response == null) {
      throw WebScraperException(
          'getElement cannot be called before loadWebPage');
    }
    // Using html parser and query selector to get a list of particular element.
    var document = parse(_response.body);
    var elements = document.querySelectorAll(address);
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
