import 'package:flutter_shine/flutter_shine.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'util/dialog.dart';
import 'util/firebase_manager.dart';
import 'util/global.dart';

class EmailFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!EmailValidator.validate(value)) {
      return 'Invalid email format';
    }
    return null;
  }
}

class UsernameFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Username can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class CodeFieldValidator {
  static String validate(String value) {
    if (value == '') {
      return 'Code is required';
    } else if (value.length < 6) {
      return 'Code should be 6 digit long';
    }
    return null;
  }
}

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    FirebaseManager.setCurrentScreen('LoginPage');
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    // _getCredentials();
  }

  _getCredentials() async {
    print(secureStorage.readAll());
    String username, email;
    username = await secureStorage.read(key: 'username');
    email = await secureStorage.read(key: 'email');
    if (username == null || username.isEmpty) {
    } else {
      if (email == null || email.isEmpty) {
      } else {
        setState(() {
          _usernameControllerLogin.text = username;
          _emailControllerLogin.text = email;
        });
      }
    }
  }

  bool _isLoading = false;

  bool _isCodeSent = false;

  TextEditingController _usernameControllerLogin = TextEditingController();
  TextEditingController _emailControllerLogin = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  final _loginForm = GlobalKey<FormState>();
  final _registerForm = GlobalKey<FormState>();
  final _codeForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: greyBackground(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoading ? customLoader() : tabBar(),
          bottomSheet: TabBar(
            // unselectedLabelColor: Colors.white,
            labelColor: ThemeConstants.primaryColor,
            tabs: [
              new Tab(
                text: "LOGIN",
              ),
              new Tab(text: "REGISTER")
            ],
            controller: _tabController,
          )),
    );
  }

  Widget tabBar() {
    return TabBarView(
      children: [
        loginCard(),
        userMakeCard(),
      ],
      controller: _tabController,
    );
  }

  Widget loginCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/virus.png',
                height: 80,
                color: ThemeConstants.primaryTextColor,
              ),
            ),
            Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _loginForm,
                  autovalidate: true,
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        'Enter your email and unique username below',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextFormField(
                        key: Key('LoginEmail'),
                        validator: EmailFieldValidator.validate,
                        controller: _emailControllerLogin,
                        decoration: InputDecoration(hintText: 'Enter email'),
                      ),
                      TextFormField(
                        key: Key('LoginUsername'),
                        validator: UsernameFieldValidator.validate,
                        controller: _usernameControllerLogin,
                        decoration: InputDecoration(
                            hintText: 'Enter username',
                            helperText: '(Do not share with anyone)'),
                      ),
                      GestureDetector(
                        key: Key('LoginButton'),
                        onTap: () async {
                          await doLogin();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/gradientbox.png'),
                                    fit: BoxFit.fill)),
                            child: Center(
                              child: Text("LOGIN",
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userMakeCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/virus.png',
                height: 80,
                color: ThemeConstants.primaryTextColor,
              ),
            ),
            Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  autovalidate: true,
                  key: _registerForm,
                  child: Wrap(
                    children: <Widget>[
                      Text(
                        'Welcome! Enter your name, email and preferred username for entry',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextFormField(
                        key: Key('RegName'),
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter name',
                        ),
                        validator: UsernameFieldValidator.validate,
                      ),
                      TextFormField(
                        key: Key('RegEmail'),
                        controller: _emailController,
                        enabled: !_isCodeSent,
                        decoration: InputDecoration(hintText: 'Enter email'),
                        validator: EmailFieldValidator.validate,
                      ),
                      TextFormField(
                        key: Key('RegUsername'),
                        controller: _usernameController,
                        enabled: !_isCodeSent,
                        decoration: InputDecoration(
                            hintText: 'Enter username',
                            helperText: '(Do not share with anyone)'),
                        validator: UsernameFieldValidator.validate,
                      ),
                      GestureDetector(
                        key: Key('CreateUserButton'),
                        onTap: () async {
                          await _sendCode();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/gradientbox.png'),
                                    fit: BoxFit.fill)),
                            child: Center(
                              child: Text("CREATE USER",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ThemeConstants.primaryColor)),
                            ),
                          ),
                        ),
                      ),
                      _isCodeSent
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                children: <Widget>[
                                  Form(
                                    autovalidate: true,
                                    key: _codeForm,
                                    child: TextFormField(
                                      key: Key('RegCode'),
                                      maxLength: 6,
                                      validator: CodeFieldValidator.validate,
                                      controller: _codeController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          hintText: 'Enter code here'),
                                    ),
                                  ),
                                  GestureDetector(
                                    key: Key('RegisterButton'),
                                    onTap: () async {
                                      await _verifyCodeAndRegister();
                                      // _tabController.animateTo(0);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/gradientbox.png'),
                                                fit: BoxFit.fill)),
                                        child: Center(
                                          child: Text("REGISTER",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: ThemeConstants
                                                      .primaryColor)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendCode() async {
    if (!_registerForm.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      // Response response = await networkApi.sendCode(
      //     _emailController.text.toString(),
      //     _usernameController.text.toString());
      // if (response.status == "1") {
      await showSuccessAlertDialog(context, 'Code Sent');
      setState(() {
        _isCodeSent = true;
      });
      // } else if (response.status == "0") {
      //   showFailureAlertDialog(context, response.message);
      // }
    } catch (e) {
      showFailureAlertDialog(context, 'Failed to process request');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _verifyCodeAndRegister() async {
    if (!_codeForm.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // Response response = await networkApi.verifyCodeAndRegisterUser(
      //     _nameController.text.toString(),
      //     _usernameController.text.toString(),
      //     _emailController.text.toString(),
      //     _codeController.text.toString());
      // if (response.status == "1") {
      _resetRegTab();
      await showSuccessAlertDialog(context, 'Thank you for registering');
      _tabController.animateTo(0);
      // } else if (response.status == "0") {
      //   showFailureAlertDialog(context, response.message);
      // }
    } catch (e) {
      showFailureAlertDialog(context, 'Failed to process request');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _resetRegTab() {
    setState(() {
      _nameController.clear();
      _usernameController.clear();
      _emailController.clear();
      _codeController.clear();
      _isCodeSent = false;
    });
  }

  doLogin() async {
    if (!_loginForm.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // Response response = await networkApi.loginUser(
      //     _usernameControllerLogin.text.toString(),
      //     _emailControllerLogin.text.toString());
      // if (response.status == "1") {
      //   cache.loggedIn = true;
      //   secureStorage.write(
      //       key: 'username', value: _usernameControllerLogin.text.toString());
      //   secureStorage.write(
      //       key: 'email', value: _emailControllerLogin.text.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'My Qurantine Diary'),
          ),
          (Route<dynamic> route) => false);
      // } else if (response.status == "0") {
      //   showFailureAlertDialog(context, response.message);
      // }
    } catch (e) {
      showFailureAlertDialog(context, 'Failed to process request');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
