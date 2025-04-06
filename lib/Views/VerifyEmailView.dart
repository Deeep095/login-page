import 'package:flutter/material.dart';
import 'package:untitled1/Constants/routes.dart';
import 'package:untitled1/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  final String? email;
  const VerifyEmailView(this.email, {super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

Future<Object?> customEmailVerificationDialog(BuildContext context, String email,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Verify Email",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (_, animation, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 500,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const Text(
                    "Verify Email ",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Please verify your email. An email has been sent to the provided email address.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "If you haven't received a verification email, press the button below to resend it!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    (email.isNotEmpty
                        ? 'Please verify your email: $email'
                        : 'No email provided.'),
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () async {
                      AuthServices.firebase().sendEmailVerification();
                    },
                    child: const Text("Send Verification Email"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await AuthServices.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        onBoardingScreenRoute,
                            (route) => false,
                      );
                    },
                    child: const Text("Back to Onboarding"),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final String? email = widget.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Verify Email",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Text(
            "Please verify your email. A verification email has been sent.",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Text(
            "If you haven't received it, press the button below to resend!",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            (email != null
                ? 'Please verify your email: $email'
                : 'No email provided.'),
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () async {
              AuthServices.firebase().sendEmailVerification();
            },
            child: const Text("Send Verification Email"),
          ),
          TextButton(
            onPressed: () async {
              await AuthServices.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                    (route) => false,
              );
            },
            child: const Text("Register Again"),
          ),
        ],
      ),
    );
  }
}
