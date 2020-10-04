import 'http.dart';
import 'network_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String appId = "q35urw9";
  static const String deviceId = "slkdnb#@<>%@FEli";
}

final HttpDataSource dataSource = HttpDataSource();
final NetworkApi networkApi = NetworkApi();
final GlobalCache cache = GlobalCache();
final secureStorage = FlutterSecureStorage();

class ThemeConstants {
  static Color primaryColor = Colors.grey[700];
  static Color primaryColorLight = Colors.white;
  static Color primaryColorDark = Color(0xFF0066B3);
  static Color accentColor = Color(0xFFEF4123);
  static Color accentLightColor = Color(0xFFFDB71A);
  static Color barTitleColor = Color(0xffffff);
  // static Color primaryTextColor = Color(0xDE000000);
  // static Color secondaryTextColor = Color(0x8A000000);
  static Color disabledHintAndIconColor = Color(0xFFFDB71A);
  static Color iconColor = Color(0xFF21213d);
  static Color offWhiteColor = Color(0xFFFAFAFA);
  static Color dividerColor = Color(0x1F000000);
  static Color cardViewBackgroundColor = Color(0xFFE7E7E7);
  static Color cardShadowColor = Color(0xFFBDBDBD);
  static Color cardBackgroundColor = Color(0xFFFFFFFF);
  static Color debitAmountColor = Color(0xFFF44336);
  static Color creditAmountColor = Color(0xFF4CAF50);

  static Color primaryTextColor = Colors.white;
  static Color secondaryTextColor = Colors.black;
  static Color titleColor = Colors.white;
  static Color cashIn = Colors.green;
  static Color cashOut = Colors.red;
}

class Paths {
  static const String website = 'https://cestik.com/';
  static const String baseUrl = 'http://cestik.com/coviid/';
  static const String checkConnection = '$baseUrl/connection.php';
  static const String sendCode = '$baseUrl/sendcode.php';
  static const String registerUser = '$baseUrl/verifyandregister.php';
  static const String loginUser = '$baseUrl/signin.php';
  static const String allCovidDetails = '$baseUrl/fetchCovidDetails.php';
  static const String getMyEntries = '$baseUrl/fetchUserDiary.php';
  static const String addEntry = '$baseUrl/addEntry.php';
  static const String addSuggestion = '$baseUrl/addSuggestion.php';
}

class GlobalCache {
  User currentUser;
  bool loggedIn = false;
}

class Response {
  String status;
  String message;

  Response({this.status, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class User {
  String userId;
  String name;
  String userName;
  String userEmail;

  User({this.userId, this.name, this.userName, this.userEmail});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    userName = json['user_name'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    return data;
  }
}

class CovidDetails {
  String detailHeading;
  String detailText;

  CovidDetails({this.detailHeading, this.detailText});

  CovidDetails.fromJson(Map<String, dynamic> json) {
    detailHeading = json['detail_heading'];
    detailText = json['detail_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detail_heading'] = this.detailHeading;
    data['detail_text'] = this.detailText;
    return data;
  }
}

class Entry {
  String name;
  String entryId;
  String entryTitle;
  String entryText;
  String entryTime;

  Entry(
      {this.name,
      this.entryId,
      this.entryTitle,
      this.entryText,
      this.entryTime});

  Entry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    entryId = json['entry_id'];
    entryTitle = json['entry_title'];
    entryText = json['entry_text'];
    entryTime = json['entry_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['entry_id'] = this.entryId;
    data['entry_title'] = this.entryTitle;
    data['entry_text'] = this.entryText;
    data['entry_time'] = this.entryTime;
    return data;
  }
}
// Font: Montserrat
// Color Code:
// Background Gradient
// Color 1: #000000
// Color 2: #3a3a3a

// Box Gradient
// Color 1: #a3f8ff
// Color 2: #deffc9

Widget customLoader() {
  return Center(
      child: CircularProgressIndicator(
    backgroundColor: ThemeConstants.primaryColorLight,
  ));
}

BoxDecoration greyBackground() {
  return BoxDecoration(
      color: ThemeConstants.primaryColor,
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white38, ThemeConstants.primaryColor])
      // image: DecorationImage(image: AssetImage('assets/virus.png')),
      );
}
