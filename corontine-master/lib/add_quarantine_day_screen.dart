import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'util/dialog.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';

class AddDayPage extends StatefulWidget {
  AddDayPage({this.title});

  final String title;

  @override
  _AddDayPageState createState() => _AddDayPageState();
}

class _AddDayPageState extends State<AddDayPage> {
  bool _isLoading = false;
  final _entryForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    FirebaseManager.setCurrentScreen('AddNewDayPage');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topRight,
      //         end: Alignment.bottomLeft,
      //         colors: [Colors.greenAccent, Colors.white38])),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title,
              style: TextStyle(color: ThemeConstants.primaryColorLight)),
          actions: <Widget>[
            // IconButton(onPressed: () {}, icon: Icon(Icons.add))
          ],
        ),
        body: _isLoading ? customLoader() : _body(),
      ),
    );
  }

  TextEditingController _titleFieldController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  bool _isPrivate = false;

  _addEntry() async {
    if (!_entryForm.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String now = new DateTime.now().toString();
    try {
      Response res = await networkApi.addNewEntry(cache.currentUser.userId,
          _titleFieldController.text, _textFieldController.text, now, _isPrivate);
      if (res.status == '1') {
        await showSuccessAlertDialog(context, res.message);
        // Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyHomePage(title: 'My Qurantine Diary'),
            ),
            (Route<dynamic> route) => false);
      } else {
        showSuccessAlertDialog(context, res.message);
      }
    } catch (e) {
      showFailureAlertDialog(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _entryForm,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Hi there! Let others know how your day went",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextFormField(
              validator: (String value) {
                if (value == '') {
                  return 'This cannot be empty';
                } else if (value.length < 10) {
                  return 'Minimum 10 characters required';
                }
                return null;
              },
              controller: _titleFieldController,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: "Give it a title",
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                minLines: 10,
                maxLines: 100,
                validator: (String value) {
                  if (value == '') {
                    return 'This cannot be empty';
                  } else if (value.length < 150) {
                    return 'Minimum 150 characters required';
                  }
                  return null;
                },
                controller: _textFieldController,
                maxLength: 5000,
                decoration: InputDecoration(
                  hintText: "Explain your day here!",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ListTile(
              title: Text(_isPrivate ? 'Public' : 'Private'),
              trailing: Switch(
                  value: _isPrivate,
                  onChanged: (value) async {
                    setState(() {
                      _isPrivate = value;
                    });
                  }),
            ),
            GestureDetector(
              onTap: () async {
                await _addEntry();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/gradientbox.png'),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: Text("UPDATE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemeConstants.primaryColor)),
                  ),
                ),
              ),
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: RaisedButton(
            //           color: Colors.red,
            //           onPressed: () async {
            //             await _addEntry();
            //           },
            //           child: Text("Update",
            //               style: TextStyle(color: Colors.white))),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
