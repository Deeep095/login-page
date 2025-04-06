import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:untitled1/Constants/ColorConstants.dart';
import 'package:untitled1/Utilities/rive_utils.dart';

import '../Models/rive_models.dart';
import '../Views/ClassInsides/Components/animated_bar.dart';
import '../Views/HomeScreen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  get devtools => null;

  RiveAssets selectedBottomNav = bottomNavigations.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: const HomeScreen(),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 30),
          decoration: BoxDecoration(
            color: backgroundColor2.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                  bottomNavigations.length,
                      (index) => GestureDetector(
                      onTap: () {
                        bottomNavigations[index].input!.change(true);

                        if (bottomNavigations[index] != selectedBottomNav) {
                          setState(() {
                            selectedBottomNav = bottomNavigations[index];
                          });
                        }

                        Future.delayed(const Duration(seconds: 1), () {
                          bottomNavigations[index].input!.change(false);
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          AnimatedBar(isActive: bottomNavigations[index] == selectedBottomNav),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: Opacity(
                              opacity:
                              bottomNavigations[index] == selectedBottomNav
                                  ? 1
                                  : 0.5,
                              child: RiveAnimation.asset(
                                "assets/Rive_Animation/icons.riv",
                                artboard: bottomNavigations[index].artboard,
                                onInit: (artboard) {
                                  StateMachineController controller = RiveUtils.getRiveController(artboard,stateMachineName: bottomNavigations[index].stateMachineName);
                                  bottomNavigations[index].input = controller.findSMI("active") as SMIBool;
                                },
                              ),
                            ),
                          )
                        ],
                      ))),
            ],
          ),

        ),
      ),
    );
  }
}




