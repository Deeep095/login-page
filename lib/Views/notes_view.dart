import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:untitled1/Constants/ColorConstants.dart';
import 'package:untitled1/Utilities/rive_utils.dart';

import '../Constants/routes.dart';
import '../Models/rive_models.dart';
import '../enums/menu_actions.dart';
import '../services/auth/auth_service.dart';
import 'ClassInsides/Components/animated_bar.dart';
import 'HomeScreen.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  get devtools => null;

  RiveAssets selectedBottomNav = bottomNavigations.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: const HomeScreen(),
        // appBar: AppBar(
        //     backgroundColor: Colors.indigoAccent,
        //     title: const Text(
        //       "Main UI ",
        //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //     ),
        //     actions: [
        //       PopupMenuButton<MenuAction>(
        //         onSelected: (value) async {
        //           switch(value)
        //           {
        //             case MenuAction.logout:
        //               final shouldLogout = await showLogOutDialog(context);
        //               // devtools.log(shouldLogout.toString());     //cannot use here
        //               if(shouldLogout) {
        //                 await AuthServices.firebase().logOut();
        //                 Navigator.of(context).pushNamedAndRemoveUntil(onBoardingScreenRoute, (route) => false);
        //               }
        //               break;
        //           }
        //         },
        //         itemBuilder: (context) {
        //           return const [
        //             PopupMenuItem<MenuAction>(
        //               value: MenuAction.logout,
        //               child: Text("log out"),
        //             ),
        //           ];
        //         },
        //       )
        //     ],
        //   ),

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




