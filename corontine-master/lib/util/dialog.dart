import 'package:flutter/material.dart';

import '../home_screen.dart';

Future showAlertDialog(
    BuildContext context, String title, String message) async {
  await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: Text(title),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: new Text('OK'))
      ],
    ),
  );
}

Future showFailureAlertDialog(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => new AlertDialog(
      title: Icon(
        Icons.cancel,
        color: Colors.red,
        size: 80.0,
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context), child: new Text('OK'))
      ],
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Future showSuccessAlertDialog(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => new AlertDialog(
      key: Key('AlertDialog'),
      title: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 80.0,
      ),
      actions: <Widget>[
        FlatButton(
            key: Key('OKButton'),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
            },
            child: new Text('OK'))
      ],
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Future showSuccessAlertDialogWithNavigationToHome(
    BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => new AlertDialog(
      title: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 80.0,
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
                (Route<dynamic> route) => false),
            child: new Text('OK'))
      ],
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Future showBlockingAlertDialog(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: new AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.red,
              size: 80.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  );
}

Future showAlertDialogLogout(BuildContext context, String title, String message,
    Function onPressedOk, Function onPressedCancel) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: onPressedCancel, child: Text('Cancel')),
        FlatButton(onPressed: onPressedOk, child: Text('OK'))
      ],
    ),
  );
}

Future showAlertDialogLogoutOnSessionTimeout(BuildContext context, String title,
    String message, Function onPressedOk) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[FlatButton(onPressed: onPressedOk, child: Text('OK'))],
    ),
  );
}
