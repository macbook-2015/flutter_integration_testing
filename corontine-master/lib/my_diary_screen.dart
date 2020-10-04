import 'package:coviddiary/util/animator.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import 'add_quarantine_day_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'read_entry_screen.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';

class MyDiary extends StatefulWidget {
  MyDiary({this.title});

  final String title;

  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  bool _isLoading = false;
  List<Entry> _entries = new List<Entry>();
  @override
  void initState() {
    super.initState();
    FirebaseManager.setCurrentScreen('DiaryPage');
    // _fetchUserDiary();
  }

  _fetchUserDiary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _entries = await networkApi.getMyEntries(cache.currentUser.userId);
    } catch (e) {
      // showFailureAlertDialog(context, 'Failed to process request');
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
            title: Text(widget.title,
                style: TextStyle(color: ThemeConstants.primaryColorLight)),
            actions: <Widget>[
              IconButton(
                  tooltip: 'New Entry',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddDayPage(
                          title: 'Add a new quarantine day!',
                        ),
                      ),
                    );
                  },
                  icon:
                      Icon(Icons.add, color: ThemeConstants.primaryColorLight)),
              IconButton(
                  tooltip: 'Refresh',
                  onPressed: () {
                    _fetchUserDiary();
                  },
                  icon: Icon(Icons.refresh,
                      color: ThemeConstants.primaryColorLight))
            ],
          ),
          body: _isLoading
              ? customLoader()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _entries.length > 0 || _entries.isNotEmpty
                      ? new ListView.builder(
                          itemCount: _entries.length,
                          itemBuilder: (context, index) {
                            return buildDiaryCard(index, _entries[index]);
                          },
                        )
                      : _emptyState(),
                )),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddDayPage(
                title: 'Add a new quarantine day!',
              ),
            ),
          );
        },
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(Icons.note_add),
              Text(
                'No entry found, add one right now?',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
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

    Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          onTap: () {
            _onClick(_entry);
          },
          leading: Icon(Icons.book, size: 30, color: Colors.red[700]),
          title: Text(_entry.entryTitle),
          subtitle: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: _entry.entryText.substring(0, 100),
                style: TextStyle(color: Colors.grey, fontSize: 14.0)),
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

  _onClick(Entry _entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReadEntryPage(entry: _entry),
      ),
    );
  }
}
