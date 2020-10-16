import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/login_register_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registrationscreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email;
  String password;
  bool showSpinner = false;

  void _saveForm() async {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      _firestore.collection('users').doc(result.user.uid).set({
        "email": emailController.text,
      }).then((res) {
        setState(() {
          showSpinner = false;
        });

        Navigator.pushReplacementNamed(context, ChatScreen.id);
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('ontap clicked');
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
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
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                    print(email);
                  },
                  decoration: kTextFieldInputDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    password = value;
                    print(password);
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
                  text: 'Register',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
