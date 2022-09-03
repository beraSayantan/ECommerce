import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/widgets/custom_btn.dart';
import 'package:shopping/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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

  // create a new user account
  Future<String?> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _registerEmail,
        password: _registerPassword
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
      _registerFormLoading = true;
    });

    //run the create account method
    String? _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      //set the form to regular state
      setState(() {
        _registerFormLoading = false;
      });
    }
    else {
      Navigator.pop(context);
    }
  }

  //default form loading state
  bool _registerFormLoading = false;

  //form input field values
  String _registerEmail = "";
  String _registerPassword = "";

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
      backgroundColor: Color(0xFF3EB489),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  "Create A New Account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email...",
                    onChanged: (value) {
                      _registerEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Password...",
                    onChanged: (value) {
                      _registerPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomBtn(
                    text: "Create New Account",
                    onPressed: () {
                      _submitForm();
                    },
                    outlineBtn: false,
                    isLoading: _registerFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomBtn(
                  text: "Back To Login",
                  onPressed: () {
                    Navigator.pop(context);
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
