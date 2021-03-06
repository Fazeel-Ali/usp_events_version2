// ignore_for_file: prefer_const_constructors, unnecessary_new, avoid_print
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usp_events_version2/services/AuthService.dart';
import 'package:usp_events_version2/view/profile.dart';
import 'package:usp_events_version2/view/registration.dart';
import 'package:usp_events_version2/widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // loading
  bool loading = false;
  // form key
  final _formkey = GlobalKey<FormState>();
  //firebase auth
  final AuthService _auth = AuthService();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailfield = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    //password field
    final passwordfield = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    //Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.tealAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signInUser();
        },
        child: Text(
          'LOGIN',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[800],
            body: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Container(
                    color: Colors.teal[800],
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 200,
                                child: Image.asset(
                                  'assets/logo.jpg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 45),
                              emailfield,
                              SizedBox(height: 25),
                              passwordfield,
                              SizedBox(height: 25),
                              loginButton,
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Dont't have an Account?",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationScreen()));
                                    },
                                    child: Text(
                                      "SignUp",
                                      style: TextStyle(
                                          color: Colors.tealAccent,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  // login function
  void signInUser() async {
    if (_formkey.currentState!.validate()) {
      setState(() => loading = true);
      dynamic authResult =
          await _auth.logInUser(emailController.text, passwordController.text);
      if (authResult == null) {
        setState(() => loading = false);
        Fluttertoast.showToast(
            msg: "Sign in error, could not able to login",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(
            msg: "Login successful",
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER);
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => ProfileScreen()),
            (route) => false);
      }
    }
  }
}
