import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mychat/components/datamodel.dart';
import 'package:mychat/components/roundedbutton.dart';
import 'package:mychat/components/validator.dart';
import 'package:mychat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/screens/chat_screen.dart';
import 'package:mychat/screens/login_screen.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final model = LoginDataModel(email: '', password: '');
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
                  decoration: ktextFieldDecoration.copyWith(
                      hintText: "Enter your email"),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) => evalPassword(value),
                  decoration: ktextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(height: 24.0),
                Roundedbutton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser = await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (newUser != null) {
                          Navigator.pushNamed(context, LoginScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      } finally {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }
                  },
                  title: 'Register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
