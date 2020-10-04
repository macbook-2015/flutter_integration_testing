import 'global.dart';
import 'http.dart';

class NetworkApi {
  Future<bool> checkConnection() async {
    bool res = await dataSource.getConnectionStatus('${Paths.checkConnection}');
    return res;
  }

  Future<Response> loginUser(String username, String email) async {
    var response =
        await dataSource.getLoginStatus('${Paths.loginUser}', username, email);
    if (response['status'] == "1") {
      cache.loggedIn = true;
      var res = response['user'];
      var res1 = res['0'];
      print(res1);
      cache.currentUser = User.fromJson(res1);
      return Response.fromJson(response);
    } else if (response['status'] == "0") {
      cache.loggedIn = false;
      return Response.fromJson(response);
    }
    return null;
  }

  Future<List<CovidDetails>> getCoronaDetails() async {
    var response =
        await dataSource.getCoronaDetails('${Paths.allCovidDetails}');
    List<CovidDetails> myResponseList = new List<CovidDetails>();
    for (int i = 0; i < response.length; i++) {
      myResponseList.add(CovidDetails.fromJson(response[i]));
    }
    return myResponseList;
  }

  Future<List<Entry>> getMyEntries(String userid) async {
    var response =
        await dataSource.getUserEntries('${Paths.getMyEntries}', userid);
    List<Entry> myResponseList = new List<Entry>();
    for (int i = 0; i < response.length; i++) {
      myResponseList.add(Entry.fromJson(response[i]));
    }
    return myResponseList;
  }

  Future<Response> sendCode(String email, String username) async {
    var response =
        await dataSource.sendCode('${Paths.sendCode}', email, username);
    return Response.fromJson(response);
  }

  Future<Response> verifyCodeAndRegisterUser(
      String name, String username, String email, String code) async {
    var response = await dataSource.registerUser(
        '${Paths.registerUser}', name, username, email, code);
    return Response.fromJson(response);
  }

  Future<Response> addNewEntry(
      String userid, String title, String text, String time, bool _isPrivate) async {
    var response = await dataSource.addNewEntry(
        '${Paths.addEntry}', userid, title, text, time, _isPrivate);
    return Response.fromJson(response);
  }

  Future<Response> addNewSuggestion(
      String userid, String title, String text, String time) async {
    var response = await dataSource.addNewSuggestion(
        '${Paths.addSuggestion}', userid, title, text, time);
    return Response.fromJson(response);
  }

  // Future<List<CountryCoronaCases>> getAllCountryCoronaCases() async {
  //   var response = await dataSource.getAllCountryCoronaCases();
  //   List<CountryCoronaCases> myResponseList = new List<CountryCoronaCases>();
  //   for (int i = 0; i < response.length; i++) {
  //     myResponseList.add(CountryCoronaCases.fromJson(response[i]));
  //   }
  //   return myResponseList;
  // }
}
