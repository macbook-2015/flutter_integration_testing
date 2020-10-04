import 'package:coviddiary/util/http.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import 'add_quarantine_day_screen.dart';
import 'auth_screen.dart';
import 'corona_details_screen.dart';
import 'live_stats_screen.dart';
import 'my_diary_screen.dart';
import 'suggestions_screen.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';
import 'read_entry_screen.dart';
import 'util/animator.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  bool _isAllCasesLoading = false;
  List<Entry> _entries = new List<Entry>();
  @override
  void initState() {
    super.initState();
    // _fetchUserDiary();
    // getAllCases();
    FirebaseManager.setCurrentScreen('HomePage');
    // FirebaseManager.setCurrentUser(cache.currentUser.userName);
  }

  _fetchUserDiary() async {
    try {
      _entries = await networkApi.getMyEntries('all');
      setState(() {});
    } catch (e) {
      // showFailureAlertDialog(context, 'Failed to process request');
    }
  }

  AllCases allCases;
  getAllCases() async {
    // setState(() {
    //   _isAllCasesLoading = true;
    // });
    // try {
    //   allCases = await dataSource.getAllCases();
    // } catch (e) {} finally {
    //   setState(() {
    //     _isAllCasesLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: greyBackground(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: _drawerBody(),
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  key: Key('DrawerIcon'),
                  icon: Image.asset('assets/menu.png',
                      color: ThemeConstants.primaryColorLight),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Text('User\'s Quarantine Diary',
                style: TextStyle(color: ThemeConstants.primaryColorLight)),
            actions: <Widget>[
              IconButton(
                  tooltip: 'Logout',
                  onPressed: () {
                    _logout();
                  },
                  icon: Icon(Icons.power_settings_new,
                      color: ThemeConstants.primaryColorLight))
            ],
          ),
          body: _isLoading ? customLoader() : _userExistCard(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ThemeConstants.primaryColorLight,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddDayPage(
                    title: 'Add a new quarantine day!',
                  ),
                ),
              );
            },
            tooltip: 'Add new day',
            child: Icon(
              Icons.add,
              color: ThemeConstants.primaryColor,
            ),
          )),
    );
  }

  Widget _widgetCard(
      IconData _icon, String title, String subtitle, Function f) {
    return WidgetANimator(
      GradientCard(
        margin: const EdgeInsets.only(right: 8, left: 8, top: 8.0),
        gradient: Gradients.deepSpace,
        child: ListTile(
          onTap: f,
          leading:
              Icon(_icon, size: 30, color: ThemeConstants.primaryColorLight),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 18, color: ThemeConstants.primaryColorLight)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(subtitle,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: ThemeConstants.primaryColorLight)),
          ),
        ),
        shadowColor: Gradients.coldLinear.colors.last.withOpacity(0.2),
        elevation: 6,
      ),
    );
  }

  Widget worldStatsCard() {
    return WidgetANimator(
      GradientCard(
        margin: const EdgeInsets.only(right: 8, left: 8, top: 8.0),
        gradient: Gradients.taitanum,
        child: ListTile(
          leading: Image.asset('assets/globe.png',
              height: 35, width: 35, color: ThemeConstants.primaryColorLight),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('Current World Stats',
                style: TextStyle(
                    fontSize: 18, color: ThemeConstants.primaryColorLight)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Total Cases: ',
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemeConstants.primaryColorLight)),
                    Text('0',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: ThemeConstants.primaryColorLight)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Active Cases: ',
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemeConstants.primaryColorLight)),
                    Text('0',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: ThemeConstants.primaryColorLight)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Deaths: ',
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemeConstants.primaryColorLight)),
                    Text('0',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: Colors.red)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Recovered: ',
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemeConstants.primaryColorLight)),
                    Text('0',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ),
        shadowColor: Gradients.coldLinear.colors.last.withOpacity(0.2),
        elevation: 6,
      ),
    );
  }

  Widget _userExistCard() {
    return ListView(
      children: <Widget>[
        !_isAllCasesLoading ? worldStatsCard() : Container(),
        _widgetCard(Icons.book, 'User\'s Diary',
            'All of your entries are saved for you to see', () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyDiary(title: 'My Diary'),
            ),
          );
        }),
        // _widgetCard(Icons.view_headline, 'Tips and techniques',
        //     'It is better to protect yourself than regret later', () {}),
        _entries.length > 0 || _entries.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text("Stories by other people",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return buildDiaryCard(index, _entries[index]);
                      },
                    ),
                  ),
                ],
              )
            : Container()
      ],
    );
  }

  Widget buildDiaryCard(int index, Entry _entry) {
    return WidgetANimator(
      GradientCard(
        gradient: Gradients.deepSpace,
        shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          onTap: () {
            _onClick(_entry);
          },
          leading: Icon(Icons.book,
              size: 30, color: ThemeConstants.primaryColorLight),
          title: Text(_entry.entryTitle,
              style: TextStyle(color: ThemeConstants.primaryColorLight)),
          subtitle: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: _entry.entryText.substring(0, 100),
                style: TextStyle(
                    color: ThemeConstants.primaryColorLight, fontSize: 14.0)),
            TextSpan(
                text: '....Read More',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _onClick(_entry);
                  }),
          ])),
        ),
      ),
    );
  }

  _logout() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: Text("Logout"),
        content: new Text("Are you sure you want to logout?"),
        actions: <Widget>[
          new FlatButton(
              key: Key('Logout_No'),
              onPressed: () => Navigator.pop(context),
              child: new Text("No")),
          new FlatButton(
              key: Key('Logout_Yes'),
              onPressed: () async {
                cache.loggedIn = false;
                // secureStorage.deleteAll();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: new Text("Yes"))
        ],
      ),
    );
  }

  _onClick(Entry _entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReadEntryPage(entry: _entry),
      ),
    );
  }

  _drawerBody() {
    return Drawer(
      key: Key('Drawer'),
      child: Container(
        color: ThemeConstants.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CoronaDetailsPage(),
                        ),
                      );
                    },
                    leading: Icon(Icons.speaker_notes,
                        color: ThemeConstants.primaryColorLight),
                    title: Text("COVID-19",
                        style: TextStyle(
                            fontSize: 20,
                            color: ThemeConstants.primaryColorLight))),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LiveUpdatesPage(),
                        ),
                      );
                    },
                    leading: Image.asset('assets/globe.png',
                        height: 30,
                        width: 30,
                        color: ThemeConstants.primaryColorLight),
                    title: Text("COUNTRY WISE STATS",
                        style: TextStyle(
                            fontSize: 20,
                            color: ThemeConstants.primaryColorLight))),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SuggestionsPage(),
                        ),
                      );
                    },
                    leading: Icon(Icons.message,
                        color: ThemeConstants.primaryColorLight),
                    title: Text("SUGGESTIONS",
                        style: TextStyle(
                            fontSize: 20,
                            color: ThemeConstants.primaryColorLight))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WebviewScaffold(
                                url: Paths.website,
                                appBar: AppBar(
                                  title: new Text('Cestik'),
                                ),
                              )));
                    },
                    child: Text("powered by Cestik\u00a9",
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemeConstants.primaryColorLight))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
