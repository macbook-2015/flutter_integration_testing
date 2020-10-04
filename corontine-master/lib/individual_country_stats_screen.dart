import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'util/animator.dart';
import 'util/dialog.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';
import 'util/http.dart';

class CountryStatsPage extends StatefulWidget {
  CountryStatsPage({this.iso3});
  final String iso3;
  @override
  _CountryStatsPageState createState() => _CountryStatsPageState();
}

class _CountryStatsPageState extends State<CountryStatsPage> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    FirebaseManager.setCurrentScreen('LiveUpdatesPage');
    _getOneCountryCases();
  }

  CountryCoronaCases countryCoronaCases;
  _getOneCountryCases() async {
    setState(() {
      _isLoading = true;
    });
    try {
      countryCoronaCases = await dataSource.getOneCountryCases(widget.iso3);
    } catch (e) {
      showFailureAlertDialog(
          context, 'Unable to fetch details.\nNetwork Error!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: greyBackground(),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                title: Text('COVID-19 Live Updates',
                    style: TextStyle(color: ThemeConstants.primaryColorLight))),
            body: _isLoading
                ? customLoader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        WidgetANimator(Card(
                          child: ListTile(
                              leading: Image.network(
                                countryCoronaCases.countryInfo.flag,
                                height: 50,
                                width: 50,
                              ),
                              title: Text(countryCoronaCases.country,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black))),
                        )),
                        customCard(
                            'Today Cases',
                            countryCoronaCases.todayCases.toString(),
                            Colors.black),
                        customCard(
                            'Today Deaths',
                            countryCoronaCases.todayDeaths.toString(),
                            Colors.red),
                        customCard('Total Cases',
                            countryCoronaCases.cases.toString(), Colors.black),
                        customCard('Total Deaths',
                            countryCoronaCases.deaths.toString(), Colors.red),
                        customCard(
                            'Total Recovered',
                            countryCoronaCases.recovered.toString(),
                            Colors.green),
                        customCard('Active Cases',
                            countryCoronaCases.active.toString(), Colors.black),
                        customCard('Critical Cases',
                            countryCoronaCases.critical.toString(), Colors.red),
                      ],
                    ),
                  )));
  }

  Widget customCard(String title, String data, Color color) {
    return WidgetANimator(Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text('$title: ',
                style: TextStyle(fontSize: 14, color: Colors.black)),
            Text(data,
                style: TextStyle(
                    fontFamily: 'PTS75F', fontSize: 18, color: color)),
          ],
        ),
      ),
    ));
  }
}
