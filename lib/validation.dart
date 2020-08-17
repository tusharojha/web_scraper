library web_scraper;

class Validation {
  static RegExp _ipv6 =
      RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');
  static RegExp _ipv4Maybe =
      new RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

  //
  ValidationRet isBaseURL(String str) {
    const protocols = ['http', 'https'];
    var protocol, split, host;

    // check protocol
    split = str.split('://');
    if (split.length > 1) {
      protocol = _shift(split);
      if (protocols.indexOf(protocol) == -1) {
        return ValidationRet(false, "use [http/https] protocol");
      }
    } else {
      return ValidationRet(false,
          "bring url to the format scheme:[//]domain; EXAMPLE: https://google.com");
    }

    // check host
    host = _removeUnnecessarySlash(_shift(split));
    if (!_isIP(host) && !_isFQDN(host) && host != 'localhost') {
      return ValidationRet(
          false, "URL should contain only domain without path");
    }
    return ValidationRet(true, "ok");
  }

  //remove unnecessary '/' after domain.
  // It was: 'google.com////' It became 'google.com';
  // It was: 'google.com//search//' It became 'google.com/search';
  String _removeUnnecessarySlash(String str) {
    var s = str.split("/");
    if (s.length > 1) {
      List<String> hostSlice = [];
      s.forEach((String e) {
        if (e.length > 0) {
          hostSlice.add(e);
        }
      });
      String newStr = "";
      var i = 0;
      hostSlice.forEach((String e) {

        if (i > 0) {
          newStr = newStr+"/"+e;
        } else {
          newStr += e;
        }
        i++;
      });
      str = newStr;
    }
    return str;
  }

  _shift(List l) {
    if (l.length >= 1) {
      var first = l.first;
      l.removeAt(0);
      return first;
    }
    return null;
  }

  bool _isIP(String str, [/*<String | int>*/ version]) {
    version = version.toString();
    if (version == 'null') {
      return _isIP(str, 4) || _isIP(str, 6);
    } else if (version == '4') {
      if (!_ipv4Maybe.hasMatch(str)) {
        return false;
      }
      var parts = str.split('.');
      parts.sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    }
    return version == '6' && _ipv6.hasMatch(str);
  }

  bool _isFQDN(String str,
      {bool requireTld = true, bool allowUnderscores = false}) {
    var parts = str.split('.');
    if (requireTld) {
      var tld = parts.removeLast();
      if (parts.length == 0 || !new RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
        return false;
      }
    }

    for (var part in parts) {
      if (allowUnderscores) {
        if (part.contains('__')) {
          return false;
        }
      }
      if (!new RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
        return false;
      }
      if (part[0] == '-' ||
          part[part.length - 1] == '-' ||
          part.indexOf('---') >= 0) {
        return false;
      }
    }
    return true;
  }
}

class ValidationRet {
  bool Is;
  String Description;

  ValidationRet(this.Is, this.Description);
}
