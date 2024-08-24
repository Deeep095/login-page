
import 'package:flutter/material.dart';
import 'dart:developer' as devtools
    show log;

import 'package:untitled1/Constants/routes.dart';
import 'package:untitled1/Utilities/showErrorDialog.dart';
import 'package:untitled1/services/auth/auth_service.dart';

import '../services/auth/auth_excepions.dart'; // personalizing the log in-build function as devtools.log


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;        // late means not ready right now but promise that it will be assigned something
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //after initialize we need to dispose it so override dispose

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  bool isValidPassword(String password) {
    // Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,

        title: const Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email id here",

            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password id here",

            ),
          ),

          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;

                if (isValidPassword(password) && isValidEmail(email)) {
                  await AuthServices.firebase().createUser(email: email, password: password);
                  final user = AuthServices.firebase().currentUser;
                  devtools.log(AuthServices.firebase().currentUser.toString());
                  devtools.log(user.toString());
                  Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (routes) => false);
                } else if (!isValidEmail(email)) {
                  devtools.log("Invalid Email Credential");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Email Credential')),
                  );
                } else if (!isValidPassword(password) && isValidEmail(email)) {
                  devtools.log("Invalid Password Credential");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Password Credential')),
                  );
                }
              } on WeakPasswordException {
                devtools.log("Weak Password");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Weak Password')),
                );
              } on EmailAlreadyinUseException {
                devtools.log("Email is already in use. Please Sign in");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email is already in use. Please Sign in')),
                );
              } on InvalidEmailAuthException {
                devtools.log("Invalid Email. Try again");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Email. Try again')),
                );
              } on GenericAuthException {
                devtools.log(" -+-Generic authentication error.");
                await showErrorDialog(context, 'Failed to Register');
              } catch (e) {
                devtools.log(" -+-Unexpected error: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('An unexpected error occurred.')),
                );
              }
            },
            child: const Text("Click to register",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          TextButton(onPressed: (){

            Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                    (route)=> false);         // can cause error as register view may not have scaffold
          },
              child: const Text("Already Registered !! Click here to Login")),


        ],
      ),
    );

  }
}

