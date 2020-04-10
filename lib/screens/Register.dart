import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController phoneInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    phoneInputController =  new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: Text("Register",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'
            ),
          ),
        )
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Form(
          key: _registerFormKey,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  "Fill the following form",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'First Name*', hintText: "John"),
                controller: firstNameInputController,
                validator: (value) {
                  if (value.length < 3) {
                    return "Please enter a valid first name.";
                  }
                },
              ),
              TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Last Name*', hintText: "Doe"),
                  controller: lastNameInputController,
                  validator: (value) {
                    if (value.length < 3) {
                      return "Please enter a valid last name.";
                    }
                  }),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Phone*'),
                    controller: phoneInputController,
                    keyboardType: TextInputType.phone,
                  ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email*', hintText: "john.doe@gmail.com"),
                controller: emailInputController,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password*', hintText: "********"),
                controller: pwdInputController,
                obscureText: true,
                validator: pwdValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Confirm Password*', hintText: "********"),
                controller: confirmPwdInputController,
                obscureText: true,
                validator: pwdValidator,
              ),
              RaisedButton(
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'Montserrat'
                  ),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  if (_registerFormKey.currentState.validate()) {
                    if (pwdInputController.text ==
                        confirmPwdInputController.text) {
                          try {
                            FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailInputController.text,
                              password: pwdInputController.text)
                              .catchError((error) => signupError(error.code))
                          .then((currentUser) => Firestore.instance
                              .collection("users")
                              .document(currentUser.user.uid)
                              .setData({
                                "user.uid": currentUser.user.uid,
                                "fname": firstNameInputController.text,
                                "surname": lastNameInputController.text,
                                "email": emailInputController.text,
                                "phone": phoneInputController.text
                              })
                              .then((result) => {
                                showDialog(context: context,
                                  child: AlertDialog(
                                    title: Text("Alert"),
                                    content: Text("Registration Successful"),
                                    actions: <Widget>[
                                      FlatButton(onPressed: () => Navigator.of(context).pop(), 
                                      child: Text("Close"))
                                    ],
                                  )
                                ),
                                    Navigator.pushNamed(context, '/login'),
                                    firstNameInputController.clear(),
                                    lastNameInputController.clear(),
                                    emailInputController.clear(),
                                    pwdInputController.clear(),
                                    confirmPwdInputController.clear()
                                  }));
                          }catch (error) {
                            print("catche");
                            signupError(error.code);
                            return error;
                          }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please correct the errors in the form"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Already have an account?",
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'Montserrat'
                ),
              ),
              FlatButton(
                child: Text(
                  "Login here!",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ))));
  }
  signupError(String error){
    print("Signup error");
    String errorMessage;
    switch (error){
      case 'ERROR_WEAK_PASSWORD':
        errorMessage = "Password is not strong enough";
        break;
      case 'ERROR_INVALID_EMAIL':
        errorMessage = "The email you entered is formatted incorrect";
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        errorMessage = "This email is already in use";
        break;
      default:
        errorMessage = "Something wrong happend"; 
    }

    showDialog(context: context,
      child: AlertDialog(
        title: Text("Alert",style: TextStyle(color: Colors.red),),
        content: Text(errorMessage,  style: TextStyle(
            fontFamily: 'Montserrat'
          ),),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.of(context).pop(), 
          child: Text("close"))
        ],
      )
    );
  }
}