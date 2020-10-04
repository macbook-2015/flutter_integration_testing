import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'util/dialog.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';

class SuggestionsPage extends StatefulWidget {
  SuggestionsPage();

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  bool _isLoading = false;
  final _entryForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    FirebaseManager.setCurrentScreen('SuggestionsPage');
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
          title: Text('Suggestions',
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

  _addEntry() async {
    if (!_entryForm.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String now = new DateTime.now().toString();
    try {
      // Response res = await networkApi.addNewSuggestion(cache.currentUser.userId,
      //     _titleFieldController.text, _textFieldController.text, now);
      // if (res.status == '1') {
      //   await showSuccessAlertDialog(context, res.message);
      //   Navigator.of(context).pop();
      // } else {
      await showSuccessAlertDialog(context, 'Added');
      Navigator.of(context).pop();
      // }
    } catch (e) {
      showFailureAlertDialog(context, 'Failed to process request');
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                "Hi there! Your feedback is valuable for us. Help us improve by giving a nice suggestion below",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextFormField(
              key: Key('SuggestionTitle'),
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
                key: Key('SuggestionContent'),
                minLines: 5,
                maxLines: 50,
                validator: (String value) {
                  if (value == '') {
                    return 'This cannot be empty';
                  } else if (value.length < 50) {
                    return 'Minimum 50 characters required';
                  }
                  return null;
                },
                controller: _textFieldController,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: "Explain your day here!",
                  border: OutlineInputBorder(),
                ),
              ),
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
                    child: Text("SUGGEST NOW!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemeConstants.primaryColor)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
