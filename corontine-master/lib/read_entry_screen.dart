import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'util/firebase_manager.dart';
import 'util/global.dart';

class ReadEntryPage extends StatefulWidget {
  ReadEntryPage({this.entry});

  final Entry entry;

  @override
  _ReadEntryPageState createState() => _ReadEntryPageState();
}

class _ReadEntryPageState extends State<ReadEntryPage> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    FirebaseManager.setCurrentScreen('ReadEntryPage');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: greyBackground(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.entry.entryTitle),
          ),
          body: _isLoading
              ? customLoader()
              : ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Title",
                              style: TextStyle(
                                  color: ThemeConstants.primaryColorLight,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic)),
                          Text(widget.entry.entryTitle,
                              style: TextStyle(
                                  color: ThemeConstants.primaryColorLight,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("by ",
                              style: TextStyle(
                                  color: ThemeConstants.primaryColorLight,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic)),
                          Text(widget.entry.name,
                              style: TextStyle(
                                color: ThemeConstants.primaryColorLight,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('${widget.entry.entryText}',
                          style: TextStyle(
                            color: ThemeConstants.primaryColorLight,
                            fontSize: 16,
                          )),
                    )
                  ],
                )),
    );
  }
}
