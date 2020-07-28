import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String username;
  var _createAccountKey = GlobalKey<FormState>();

  void submit() {
    final form = _createAccountKey.currentState;
    if (form.validate()) {
      form.save();
      final snackbar = SnackBar(content: Text('Welcome $username'));
      _scaffoldKey.currentState.showSnackBar(snackbar);

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(parentContext,
          appTitle: 'Set up your profile',
          isAppTitle: false,
          removeHeaderBackButton: true),
      body: Container(
        child: Column(
          children: [
            Text('Create Username'),
            Form(
              key: _createAccountKey,
              autovalidate: true,
              child: TextFormField(
                validator: (value) {
                  if (value.trim().length < 3 || value.isEmpty) {
                    return 'please create a longer username between 3 and 12 characters';
                  } else if (value.trim().length > 12) {
                    return 'please create a shorter username between 3 and 12 characters';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  username = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  labelStyle: TextStyle(fontSize: 15.0),
                  hintText: "Must be at least 3 characters",
                ),
              ),
            ),
            MaterialButton(
              onPressed: submit,
              child: Text('submit'),
            )
          ],
        ),
      ),
    );
  }
}
