import 'package:flutter/material.dart';
import 'package:untitled1/Constants/routes.dart';
import 'package:untitled1/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  final String? email;
  const VerifyEmailView(this.email, {super.key});

  // Constructor to accept email
  @override
  State<VerifyEmailView> createState() => _verifyEmailViewState();

}

class _verifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final String? email = widget.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Verify Email ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Text(
            "Please verify Your Email First, it has been sent to the mail-id",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Text(
            "If u haven't received verification mail press to send again!!",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            (email != null
                ? 'Please verify your email: $email'
                : 'No email provided.'),
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          // const Text("Your Email id is : "+ email,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

          TextButton(
              onPressed: () async {
                AuthServices.firebase().sendEmailVerification();
              },
              child: const Text("Send Verification Mail")),

          TextButton(
              onPressed: () async {
                await AuthServices.firebase().logOut();

                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                ); // can cause error as register view may not have scaffold
              },
              child: const Text("Register here ")),
        ],
      ),
    );
  }
}

