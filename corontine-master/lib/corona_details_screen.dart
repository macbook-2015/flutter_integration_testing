import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'util/dialog.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';

class CoronaDetailsPage extends StatefulWidget {
  CoronaDetailsPage();
  @override
  _CoronaDetailsPageState createState() => _CoronaDetailsPageState();
}

class _CoronaDetailsPageState extends State<CoronaDetailsPage> {
  bool _isLoading = false;
  List<CovidDetails> _covidDetails = new List<CovidDetails>();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
    FirebaseManager.setCurrentScreen('CoronaVirusDetailsPage');
  }

  _fetchDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _covidDetails = await networkApi.getCoronaDetails();
    } catch (e) {
      showFailureAlertDialog(context, 'Failed to process request');
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
              title: Text('What is Coronavirus?',
                  style: TextStyle(color: ThemeConstants.primaryColorLight)),
            ),
            body: _isLoading ? customLoader() : _body()));
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _covidDetails.length > 0 || _covidDetails.isNotEmpty
              ? new ListView.builder(
                  itemCount: _covidDetails.length,
                  itemBuilder: (context, index) {
                    return _buildDetailCard(index);
                  },
                )
              : _emptyState(),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'No data found',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(int index) {
    return ListTile(
      title: Text(_covidDetails[index].detailHeading,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            decoration: TextDecoration.underline,
          )),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(_covidDetails[index].detailText,
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
