import 'package:flutter/material.dart';
import 'package:fluttergram/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  static final String id = "SIGNUPSCREEN";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      AuthService.signUpUser(context, _name, _email, _password);
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
                          decoration: InputDecoration(labelText: "Name"),
                          validator: (input) => input.trim().isEmpty
                              ? "Please input a proper name."
                              : null,
                          onSaved: (input) => _name = input,
                        ),
                      ),
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
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: 200,
                        child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          color: Colors.blue,
                          child: Text(
                            "Back to login",
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
