import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'dart:async';

import '../AuthenticationBloc.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'test@gmail.com': '12345'
};

class LoginScreen extends StatelessWidget {
  final AuthenticationBloc bloc;

  LoginScreen({this.bloc});

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      if (!users.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      bloc.login(data.name, 'token');
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'MAP App',
      logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      onSignup: _authUser,
//      onSubmitAnimationCompleted: () {
//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//          builder: (context) => LoginScreen(_streamController),
//        ));
//      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
