import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late final TextEditingController
  _email; // late means not ready right now but promise that it will be assigned something
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Login ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
          final email = _email.text;
          final password = _password.text;

          try {
            final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          }
          on FirebaseAuthException catch (e)
          {
            print("object: ${e.code}");
          }
        },
          child: const Text("Click to login",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        )
    ]
      ),
    );
  }
}
