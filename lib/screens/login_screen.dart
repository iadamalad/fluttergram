import 'package:flutter/material.dart';
import 'package:fluttergram/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "LOGINSCREEN";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AuthService.signInUser(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fluttergram",
                  style: TextStyle(fontFamily: "Billabong", fontSize: 40),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Email"),
                          validator: (input) => !input.contains("@")
                              ? "Please input a proper email."
                              : null,
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Password"),
                          validator: (input) => (input.length < 6)
                              ? "Please input a password of at least 6 characters."
                              : null,
                          onSaved: (input) => _password = input,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 200,
                        child: FlatButton(
                          onPressed: _submit,
                          child: Text(
                            "Log in",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: 200,
                        child: FlatButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "SIGNUPSCREEN"),
                          color: Colors.blue,
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
