import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'util/animator.dart';
import 'util/dialog.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';
import 'util/http.dart';

import 'individual_country_stats_screen.dart';

class LiveUpdatesPage extends StatefulWidget {
  LiveUpdatesPage();

  @override
  _LiveUpdatesPageState createState() => _LiveUpdatesPageState();
}

class _LiveUpdatesPageState extends State<LiveUpdatesPage> {
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseManager.setCurrentScreen('LiveUpdatesPage');
    _getAllCountryCoronaCases();
    _searchController.addListener(() {
      _onSearchedTextChanged(_searchController.text);
    });
    // _getOneCountryCases();
  }

  CountryCoronaCases countryCoronaCases;
  _getOneCountryCases() async {
    setState(() {
      _isLoading = true;
    });
    try {
      countryCoronaCases = await dataSource.getOneCountryCases('');
      print(_countryCoronaCases);
    } catch (e) {
      showFailureAlertDialog(
          context, 'Unable to fetch details.\nNetwork Error!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<CountryCoronaCases> _countryCoronaCases = new List<CountryCoronaCases>();
  List<CountryCoronaCases> _filteredCountryCoronaCases =
      new List<CountryCoronaCases>();
  _getAllCountryCoronaCases() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _countryCoronaCases = await dataSource.getAllCountryCoronaCases();
    } catch (e) {
      showFailureAlertDialog(
          context, 'Unable to fetch details.\nNetwork Error!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _onSearchedTextChanged(String text) async {
    _filteredCountryCoronaCases.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _countryCoronaCases.forEach((count) {
      if (count.country != null) {
        if (count.country.toLowerCase().contains(text.toLowerCase())) {
          _filteredCountryCoronaCases.add(count);
        }
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: greyBackground(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // title: Text('COVID-19 Live Updates',
            //     style: TextStyle(color: ThemeConstants.primaryColorLight)),
            title: TextField(
              decoration: InputDecoration(labelText: "Search"),
              controller: _searchController,
            ),
          ),
          body: _isLoading
              ? customLoader()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _filteredCountryCoronaCases.length > 0
                      ? _buildList(_filteredCountryCoronaCases)
                      : _buildList(_countryCoronaCases),
                ),
        ));
  }

  Widget _buildList(List<CountryCoronaCases> list) {
    return new ListView.builder(
      key: Key('CountriesList'),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildCountryCard(index, list[index]);
      },
    );
  }

  Widget buildCountryCard(int index, CountryCoronaCases subObject) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
                height: 50,
                width: 50,
                child: Image.network(
                  subObject.countryInfo.flag,
                )),
            title: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CountryStatsPage(iso3: subObject.countryInfo.iso3),
                    ),
                  );
                },
                child: Text(subObject.country)),
            trailing: subObject.show
                ? GestureDetector(
                    key: Key('Close$index'),
                    onTap: () {
                      setState(() {
                        subObject.show = false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: ThemeConstants.primaryColor,
                    ),
                  )
                : GestureDetector(
                    key: Key('Open$index'),
                    onTap: () {
                      setState(() {
                        subObject.show = true;
                      });
                    },
                    child: Icon(Icons.add, color: ThemeConstants.primaryColor)),
          ),
          subObject.show ? customDivider() : Container(),
          subObject.show
              ? ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Today's Cases: ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          Text('${subObject.todayCases}',
                              style: TextStyle(
                                  fontFamily: 'PTS75F',
                                  fontSize: 18,
                                  color: Colors.green)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Today's Deaths: ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          Text('${subObject.todayDeaths}',
                              style: TextStyle(
                                  fontFamily: 'PTS75F',
                                  fontSize: 18,
                                  color: Colors.red)),
                        ],
                      ),
                      customDivider(),
                      Row(
                        children: <Widget>[
                          Text('Total Cases: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          Text('${subObject.cases}',
                              style: TextStyle(
                                  fontFamily: 'PTS75F',
                                  fontSize: 18,
                                  color: Colors.black)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Total Deaths: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          Text('${subObject.deaths}',
                              style: TextStyle(
                                  fontFamily: 'PTS75F',
                                  fontSize: 18,
                                  color: Colors.red)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Total Recovered: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          Text('${subObject.recovered}',
                              style: TextStyle(
                                  fontFamily: 'PTS75F',
                                  fontSize: 18,
                                  color: Colors.green)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Active Cases: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          Text('${subObject.active}',
                              style: TextStyle(
                                  fontFamily: 'PTS75F',
                                  fontSize: 18,
                                  color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget customDivider() {
    return Divider(height: 2.0, color: ThemeConstants.dividerColor);
  }

  Widget customColumn(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$title: ",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          "$data",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }
}
