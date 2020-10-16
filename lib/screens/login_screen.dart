import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/login_register_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginscreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  // final _loginLineController = TextEditingController();

  void _saveForm() async {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      setState(() {
        showSpinner = false;
      });
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    }).catchError((err) {
      print(err.message);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(err.message),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  child: Text('Ok'))
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100.0,
                    child: Image.asset('images/whatsapplogo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldInputDecoration.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldInputDecoration.copyWith(
                    hintText: 'Enter your password'),
                obscureText: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              LoginRegisterWidget(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  _saveForm();
                },
                color: Colors.white,
                text: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
