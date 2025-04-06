import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;

import 'ClassOutsides/Components/AnimationButton.dart';
import 'ClassOutsides/Components/CustomSignInDialog.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isSignInDialogShown = false;

  late RiveAnimationController animationController;
  @override
  void initState() {
    animationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            // height: 100,
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: flutter_image.Image.asset("assets/Backgrounds/Spline.png"),
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
          )),
          const RiveAnimation.asset("assets/Rive_Animation/shapes.riv"),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 50,
              sigmaY: 50,
            ),
            child: const SizedBox(),
          )),

          //Adding Text

          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const SizedBox(
                  width: 220,
                  child: Column(
                    children: [
                      Text(
                        "Learn & Educate Self",
                        style: TextStyle(
                          fontSize: 60,
                          fontFamily: "Poppins",
                          height: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                          "Don't skip it !!.Its the hard work of all THE people worked for the project to be SUCCESSFULL.\nBe Kind to Everyone!!")
                    ],
                  ),
                ),

                //animations adding
                const Spacer(
                  flex: 3,
                ),
                AnimationButton(
                    animationController: animationController,
                    press: () {
                      animationController.isActive = true;

                      Future.delayed(const Duration(milliseconds: 600), () {
                        // We made it but
                        // also need to set it false once the dialog close
                        setState(() {
                          isSignInDialogShown = false;
                        });
                        // Let's add the slide animation while dialog shows
                        customSigninDialog(
                          context,
                          onClosed: (_) {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                          },
                        );
                      });
                    }),

                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                      "Another similar text only to show this all things .Please accept our PAVFM project."),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
