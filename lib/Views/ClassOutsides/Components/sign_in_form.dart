import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:untitled1/Constants/routes.dart';
import 'package:untitled1/Views/ClassInfoProvider.dart';
import 'package:untitled1/Views/HomeScreen.dart';
import 'dart:developer' as devtools show log;
import '../../../ScreensBasedOnRoles/AdminScreen.dart';
import '../../../ScreensBasedOnRoles/TeacherScreen.dart';
import '../../../Utilities/showErrorDialog.dart';
import '../../../services/auth/auth_excepions.dart';
import '../../../services/auth/auth_service.dart';
import '../../VerifyEmailView.dart';
import 'CustomSignUpDialog.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isShowLoading = false;
  bool isShowConfetti = false;

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

  late final TextEditingController _email;
  // late means not ready right now but promise that it will be assigned something
  late final TextEditingController _password;

  String? selectedRole;

  bool isSignUpDialogShown = false;
  bool isSignInDialogShown = true;

  bool isVerifyEmailDialogShown = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    selectedRole = null;
    super.initState();
  }

  void signIn(
      BuildContext context, String email, String password, String role) async {
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (_formKey.currentState!.validate()) {
          try {
            final user = await AuthServices.firebase()
                .logIn(email: email, password: password, role: role);
            if (AuthServices.firebase().currentUser!.isEmailVerified) {
              check.fire();
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  setState(() {
                    isShowLoading = false;
                  });
                  confetti.fire();
                  // Navigate & hide confetti
                  Future.delayed(const Duration(seconds: 1), () {
                    // Navigator.pop(context);
                    if (!context.mounted) return;
                    print(AuthServices.firebase().currentUser);
                    // navigateBasedOnRole(role);
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //     homeScreenRoute, (route) => false);
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => ClassInfoProvider(),
                          child: const HomeScreen(),
                        ),
                      ),
                    );
                  });
                },
              );
            } else {
              // Future.delayed(
              //   Duration(seconds: 1),
              //   () {
              //     setState(() {
              //       isShowLoading = false;
              //     });
              //   },
              // );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verify Email-id')),
              );
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
            }
          } on InvalidEmailAuthException {
            devtools.log('Invalid Email Auth Exception');
            error.fire();
            Future.delayed(
              const Duration(seconds: 2),
              () {
                setState(() {
                  isShowLoading = false;
                });
                reset.fire();
              },
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Email Auth Exception')),
            );
          } on UserNotFoundException {
            devtools.log('User Not Found');

            await showErrorDialog(context, 'User Not Found');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('User not found. Please check your email address.')),
            );
          } on WrongPasswordAuthException {
            devtools.log('Wrong Password');

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Wrong password. Please try again.')),
            );
          }
          // on GenericAuthException {
          //
          //   devtools.log('Generic Auth Exception');
          //   error.fire();
          //   Future.delayed(
          //     const Duration(seconds: 2),
          //     () {
          //       setState(() {
          //         isShowLoading = false;
          //       });
          //       reset.fire();
          //     },
          //   );
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Generic Auth Exception')),
          //   );
          // }
          catch (e) {
            devtools.log("Unexpected error: $e");
            error.fire();
            Future.delayed(
              const Duration(seconds: 1),
              () {
                setState(() {
                  isShowLoading = false;
                });
                reset.fire();
              },
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('An unexpected error occurred.')),
            );
          }
        } else {
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              reset.fire();
            },
          );
        }
      },
    );
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
    return Stack(children: [
      Form(
        key: _formKey,
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
                decoration: InputDecoration(
                  hintText: "Select your role",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset(
                        "assets/Icons/User.svg"), // Icon for role selection
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
                  setState(() {
                    selectedRole =
                        newValue!; // Assuming you have a variable to store the selected role
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
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    final role = selectedRole.toString();
                    print("$email $password $role");
                    signIn(context, email, password, role);
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
                  label: const Text("Sign In"),
                ),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16), // add some space between buttons
                ElevatedButton.icon(
                  onPressed: () {
                    // Let's add the slide animation while dialog shows
                    Navigator.of(context).pop();
                    customSignUpDialog(
                      context,
                    );
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
                  label: const Text("Sign Up"),
                ),
              ]),
            ),
          ],
        ),
      ),
      isShowLoading
          ? CustomPositioned(
              child: RiveAnimation.asset(
                'assets/Rive_Animation/check.riv',
                fit: BoxFit.cover,
                onInit: _onCheckRiveInit,
              ),
            )
          : const SizedBox(),
      isShowConfetti
          ? CustomPositioned(
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
    ]);
  }

  void navigateBasedOnRole(String role) {
    print("role = $role");
    if (role == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (role == 'Teacher') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (role == 'Student') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (role == 'hod') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const TeacherScreen()));
    } else if (role == 'professor') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const TeacherScreen()));
    } else {
      print('Role not recognized');
    }
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});

  final Widget child;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Column(
      children: [
        const Spacer(),
        SizedBox(
          height: 100,
          width: 100,
          child: child,
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    ));
  }
}
