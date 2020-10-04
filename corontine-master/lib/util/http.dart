import 'dart:convert';

import 'package:http/http.dart';

import 'global.dart';

class HttpDataSource {
  Future<bool> getConnectionStatus(String url) async {
    Uri uri = Uri.parse(url);
    var response = await get(
      uri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> sendCode(String url, String email, String username) async {
    Uri uri = Uri.parse(url);
    var response = await post(uri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"email": email, "username": username});
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> registerUser(String url, String name, String username,
      String email, String code) async {
    Uri uri = Uri.parse(url);
    var response = await post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "name": name,
      "username": username,
      "email": email,
      "code": code
    });
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> getLoginStatus(
      String url, String username, String email) async {
    Uri uri = Uri.parse(url);
    print("Username $username Email $email");
    var response = await post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "username": username,
      "email": email,
    });
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> getCoronaDetails(String url) async {
    Uri uri = Uri.parse(url);
    var response = await post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "appId": Constants.appId,
      "deviceId": Constants.deviceId,
    });
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> getUserEntries(String url, String userid) async {
    Uri uri = Uri.parse(url);
    var response = await post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "appId": Constants.appId,
      "deviceId": Constants.deviceId,
      "userid": userid
    });
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> addNewEntry(String url, String userid, String title,
      String text, String time, bool _isPrivate) async {
    Uri uri = Uri.parse(url);
    var response = await post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "appId": Constants.appId,
      "deviceId": Constants.deviceId,
      "userid": userid,
      "entry_title": title,
      "entry_text": text,
      "entry_time": time,
      "privacy": _isPrivate ? "1" : "0"
    });
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> addNewSuggestion(
      String url, String userid, String title, String text, String time) async {
    Uri uri = Uri.parse(url);
    var response = await post(uri, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "appId": Constants.appId,
      "deviceId": Constants.deviceId,
      "userid": userid,
      "sug_title": title,
      "sug_text": text
    });
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<List<CountryCoronaCases>> getAllCountryCoronaCases() async {
    Uri uri = Uri.parse(
        "https://corona.lmao.ninja/v3/covid-19/countries?sort=country");
    var response = await get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<CountryCoronaCases>((f) => CountryCoronaCases.fromJson(f))
          .toList();
    } else {
      throw Exception("Problem occurs when getting country list");
    }
  }

  Future<CountryCoronaCases> getOneCountryCases(String nameISO3) async {
    Uri uri =
        Uri.parse("https://corona.lmao.ninja/v3/covid-19/countries/$nameISO3");
    var response = await get(uri);

    if (response.statusCode == 200) {
      return CountryCoronaCases.fromJson(json.decode(response.body));
    } else {
      throw Exception("Problem occurs when getting country");
    }
  }

  Future<AllCases> getAllCases() async {
    Uri uri = Uri.parse("https://corona.lmao.ninja/v3/covid-19/all");
    var response = await get(uri);

    if (response.statusCode == 200) {
      return AllCases.fromJson(json.decode(response.body));
    } else {
      throw Exception("Problem occurs when getting All cases");
    }
  }

  Future<List<StatesCases>> getAllCasesStates() async {
    Uri uri = Uri.parse("https://corona.lmao.ninja/v3/covid-19/states");
    var response = await get(uri);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<StatesCases>((f) => StatesCases.fromJson(f))
          .toList();
    } else {
      throw Exception("Problem occurs when getting All cases");
    }
  }
}

class StatesCases {
  String state;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int active;

  StatesCases(
      {this.state,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.active});

  StatesCases.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    cases = json['cases'];
    todayCases = json['todayCases'];
    deaths = json['deaths'];
    todayDeaths = json['todayDeaths'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['cases'] = this.cases;
    data['todayCases'] = this.todayCases;
    data['deaths'] = this.deaths;
    data['todayDeaths'] = this.todayDeaths;
    data['active'] = this.active;
    return data;
  }
}

class AllCases {
  int updated;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  int casesPerOneMillion;
  double deathsPerOneMillion;
  int tests;
  double testsPerOneMillion;
  int population;
  int oneCasePerPeople;
  int oneDeathPerPeople;
  int oneTestPerPeople;
  double activePerOneMillion;
  double recoveredPerOneMillion;
  double criticalPerOneMillion;
  int affectedCountries;

  AllCases(
      {this.updated,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.todayRecovered,
      this.active,
      this.critical,
      this.casesPerOneMillion,
      this.deathsPerOneMillion,
      this.tests,
      this.testsPerOneMillion,
      this.population,
      this.oneCasePerPeople,
      this.oneDeathPerPeople,
      this.oneTestPerPeople,
      this.activePerOneMillion,
      this.recoveredPerOneMillion,
      this.criticalPerOneMillion,
      this.affectedCountries});

  AllCases.fromJson(Map<String, dynamic> json) {
    updated = json['updated'];
    cases = json['cases'];
    todayCases = json['todayCases'];
    deaths = json['deaths'];
    todayDeaths = json['todayDeaths'];
    recovered = json['recovered'];
    todayRecovered = json['todayRecovered'];
    active = json['active'];
    critical = json['critical'];
    casesPerOneMillion = json['casesPerOneMillion'];
    deathsPerOneMillion = json['deathsPerOneMillion'];
    tests = json['tests'];
    testsPerOneMillion = json['testsPerOneMillion'];
    population = json['population'];
    oneCasePerPeople = json['oneCasePerPeople'];
    oneDeathPerPeople = json['oneDeathPerPeople'];
    oneTestPerPeople = json['oneTestPerPeople'];
    activePerOneMillion = json['activePerOneMillion'];
    recoveredPerOneMillion = json['recoveredPerOneMillion'];
    criticalPerOneMillion = json['criticalPerOneMillion'];
    affectedCountries = json['affectedCountries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated'] = this.updated;
    data['cases'] = this.cases;
    data['todayCases'] = this.todayCases;
    data['deaths'] = this.deaths;
    data['todayDeaths'] = this.todayDeaths;
    data['recovered'] = this.recovered;
    data['todayRecovered'] = this.todayRecovered;
    data['active'] = this.active;
    data['critical'] = this.critical;
    data['casesPerOneMillion'] = this.casesPerOneMillion;
    data['deathsPerOneMillion'] = this.deathsPerOneMillion;
    data['tests'] = this.tests;
    data['testsPerOneMillion'] = this.testsPerOneMillion;
    data['population'] = this.population;
    data['oneCasePerPeople'] = this.oneCasePerPeople;
    data['oneDeathPerPeople'] = this.oneDeathPerPeople;
    data['oneTestPerPeople'] = this.oneTestPerPeople;
    data['activePerOneMillion'] = this.activePerOneMillion;
    data['recoveredPerOneMillion'] = this.recoveredPerOneMillion;
    data['criticalPerOneMillion'] = this.criticalPerOneMillion;
    data['affectedCountries'] = this.affectedCountries;
    return data;
  }
}

class CountryCoronaCases {
  bool show = false;
  String country;
  CountryInfo countryInfo;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  var casesPerOneMillion;
  var deathsPerOneMillion;

  CountryCoronaCases(
      {this.show,
      this.country,
      this.countryInfo,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.casesPerOneMillion,
      this.deathsPerOneMillion});

  CountryCoronaCases.fromJson(Map<String, dynamic> json) {
    show = false;
    country = json['country'];
    countryInfo = json['countryInfo'] != null
        ? new CountryInfo.fromJson(json['countryInfo'])
        : null;
    cases = json['cases'];
    todayCases = json['todayCases'];
    deaths = json['deaths'];
    todayDeaths = json['todayDeaths'];
    recovered = json['recovered'];
    active = json['active'];
    critical = json['critical'];
    casesPerOneMillion = json['casesPerOneMillion'];
    deathsPerOneMillion = json['deathsPerOneMillion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.countryInfo != null) {
      data['countryInfo'] = this.countryInfo.toJson();
    }
    data['cases'] = this.cases;
    data['todayCases'] = this.todayCases;
    data['deaths'] = this.deaths;
    data['todayDeaths'] = this.todayDeaths;
    data['recovered'] = this.recovered;
    data['active'] = this.active;
    data['critical'] = this.critical;
    data['casesPerOneMillion'] = this.casesPerOneMillion;
    data['deathsPerOneMillion'] = this.deathsPerOneMillion;
    return data;
  }
}

class CountryInfo {
  int iId;
  String country;
  String iso2;
  String iso3;
  var lat;
  var long;
  String flag;

  CountryInfo(
      {this.iId,
      this.country,
      this.iso2,
      this.iso3,
      this.lat,
      this.long,
      this.flag});

  CountryInfo.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    country = json['country'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
    lat = json['lat'];
    long = json['long'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['country'] = this.country;
    data['iso2'] = this.iso2;
    data['iso3'] = this.iso3;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['flag'] = this.flag;
    return data;
  }
}
