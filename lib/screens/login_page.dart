import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/screens/register_page.dart';
import 'package:shopping/widgets/custom_btn.dart';
import 'package:shopping/widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //build an alert dialog to display some errors
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  // login to existing user account
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail,
          password: _loginPassword
      );
      return null;
    }
    on FirebaseAuthException catch(e) {
      if(e.code == "weak-password")
        return "The password provided is too weak";
      else if(e.code == "email-already-in-use")
        return "The account already exists for that email";
      return e.message;
    }
    catch(e) {
      return e.toString();
    }
  }

  void  _submitForm() async {
    //set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    //run the create account method
    String? _loginFeedback = await _loginAccount();
    if(_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      //set the form to regular state
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  //default form loading state
  bool _loginFormLoading = false;

  //form input field values
  String _loginEmail = "";
  String _loginPassword = "";

  //Focusnode for input fields
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  "Welcome User \n Login to your account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email...",
                    onChanged: (value) {
                      _loginEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Password...",
                    onChanged: (value) {
                      _loginPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomBtn(
                    text: "Login",
                    onPressed: () {
                      _submitForm();
                    },
                    outlineBtn: false,
                    isLoading: _loginFormLoading,
                  )
                ],
              ),
              // Column(
              //   children: [
              //     CustomInput(hintText: "Email...",), //TODO
              //     CustomInput(hintText: "Password...",), //TODO
              //     CustomBtn(
              //       text: "Login",
              //       onPressed: () {
              //         print("Clicked the Login button");
              //       },
              //       outlineBtn: false,
              //       isLoading: false,
              //     )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomBtn(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage()
                        )
                    );
                  },
                  outlineBtn: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
