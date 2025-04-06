import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:untitled1/Views/ClassOutsides/Components/CustomSignInDialog.dart';
import 'dart:developer' as devtools show log;

import '../../../Utilities/showErrorDialog.dart';
import '../../../services/auth/auth_excepions.dart';
import '../../../services/auth/auth_service.dart';
import '../../VerifyEmailView.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKeySignup = GlobalKey<FormState>();

  bool isShowLoading = false;
  bool isShowConfetti = false;

  bool isSignInDialogShown = false;

  bool isVerifyEmailDialogShown = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }


  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    check = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  late final TextEditingController
      _email; // late means not ready right now but promise that it will be assigned something
  late final TextEditingController _password;
  String ? selectedRole;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    selectedRole = null;
    super.initState();
  }

  //after initialize we need to dispose it so override dispose

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> signUp(
      BuildContext context, String email, String password, String role) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    Future.delayed(const Duration(seconds: 1), () async {
      if (true) {
        try {
          if (isValidPassword(password) && isValidEmail(email)) {
            await AuthServices.firebase()
                .createUser(email: email, password: password, role: role);
            print("user created");
            // ************************* final user = AuthServices.firebase().currentUser;  ******************   // never ever write this line of code in gives Generic Auth Exception


            Future.delayed(const Duration(milliseconds: 300), () {
              // We made it but
              // also need to set it false once the dialog close
              check.fire();

              setState(() {
                isShowLoading = false;
                isVerifyEmailDialogShown = false;
              });
              confetti.fire();

              Future.delayed(const Duration(seconds: 1), () {
                customEmailVerificationDialog(
                  context,
                  email,
                  onClosed: (_) {
                    setState(() {
                      isVerifyEmailDialogShown = true;
                    });
                  },
                );
              });
              // Let's add the slide animation while dialog shows
            });

            // Navigator.of(context).pop();
          } else if (!isValidEmail(email)) {
            devtools.log("Invalid Email Credential");
            showError();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Email Credential')),
            );
          } else if (!isValidPassword(password) && isValidEmail(email)) {
            devtools.log("Invalid Password Credential");
            showError();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Password Credential')),
            );
          }
        } on WeakPasswordException {
          devtools.log("Weak Password");
          showError();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Weak Password')),
          );
        } on EmailAlreadyinUseException {
          devtools.log("Email is already in use. Please Sign in");
          showError();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Email is already in use. Please Sign in')),
          );
        } on InvalidEmailAuthException {
          devtools.log("Invalid Email. Try again");
          showError();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Email. Try again')),
          );
        } on GenericAuthException {
          devtools.log(" -+-Generic authentication error.");
          showError();
          await showErrorDialog(context, 'Failed to Register');
        } catch (e) {
          devtools.log(" -+-Unexpected error: $e");
          showError();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occurred.')),
          );
        }
      }
    });
  }

  void showError() {
    error.fire();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          isShowLoading = false;
        });
      },
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Form(
        key: _formKeySignup,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email",
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "";
                  }
                  return null;
                },
                onSaved: (email) {},
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter your email id here",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset("assets/Icons/email.svg"),
                  ),
                ),
              ),
            ),
            const Text(
              "Password",
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "";
                  }
                  return null;
                },
                onSaved: (password) {},
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter your password id here",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset("assets/Icons/password.svg"),
                  ),
                ),
              ),
            ),

            const Text(
              "Role",
              style: TextStyle(color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: "Select your role",
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.person_outline), // Icon for the role selection
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Admin",
                    child: Text("Admin"),
                  ),
                  DropdownMenuItem(
                    value: "Teacher",
                    child: Text("Teacher"),
                  ),
                  DropdownMenuItem(
                    value: "Student",
                    child: Text("Student"),
                  ),
                  DropdownMenuItem(
                    value: "HOD",
                    child: Text("HOD"),
                  ),
                  DropdownMenuItem(
                    value: "Professor",
                    child: Text("Professor"),
                  ),
                ],
                onChanged: (String? newValue) {
                  // Handle role change
                  setState(() {
                    selectedRole = newValue!; // Assuming you have a variable to store selected role
                  });
                },
                value: selectedRole, // Currently selected role
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
            ),



            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 24),
              child: Column(children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final email = _email.text;
                    final password = _password.text;
                    final role = selectedRole.toString();
                    signUp(context, email, password,role);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Sign Up"),
                ),


                const Row(
                  children: [
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),


                ElevatedButton.icon(
                  onPressed: () {
                    // Let's add the slide animation while dialog shows
                    Navigator.of(context).pop();
                    customSigninDialog(context,
                      onClosed: (_) {
                      setState(() {
                        isSignInDialogShown = true;
                      });
                    },);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF4CAF50), // green color for signup
                    minimumSize: const Size(
                        double.infinity, 40), // stretch to full width
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  label: const Text("Sign In"),
                ),


                isShowLoading
                    ? CustomPositioned2(
                        child: RiveAnimation.asset(
                          'assets/Rive_Animation/check.riv',
                          fit: BoxFit.cover,
                          onInit: _onCheckRiveInit,
                        ),
                      )
                    : const SizedBox(),
                isShowConfetti
                    ? CustomPositioned2(
                        child: Transform.scale(
                          scale: 7,
                          child: RiveAnimation.asset(
                            "assets/Rive_Animation/confetti.riv",
                            onInit: _onConfettiRiveInit,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ),
          ],
        ),
      ),
    ]);
  }
}

class CustomPositioned2 extends StatelessWidget {
  const CustomPositioned2({super.key, required this.child, this.size = 100});

  final Widget child;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose, // Use Flexible with loose fit instead of Spacer or Expanded
          child: SizedBox(
            height: size, // Adjust size as needed
            width: size,
            child: child,
          ),
        ),
      ],
    );
  }
}
