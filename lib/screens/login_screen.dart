import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mychat/components/roundedbutton.dart';
import 'package:mychat/components/validator.dart';
import 'package:mychat/constants.dart';
import 'package:mychat/screens/chat_screen.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: 48.0),
                TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => evalEmail(value),
                  decoration: ktextFieldDecoration.copyWith(hintText: 'Enter your email'),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) => evalPassword(value),
                  decoration: ktextFieldDecoration.copyWith(hintText: 'Enter your password'),
                ),
                SizedBox(height: 24.0),
                Roundedbutton(
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }
                    else{
                      return "invaild gmail or password";
                    }
                  },
                  title: 'Log In',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
