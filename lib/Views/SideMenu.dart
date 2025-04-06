import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'InfoCard.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 35.0, 0, 0),
        width: 278,
        height: double.infinity,
        color: const Color(0xFF17203A),
        child:  Column(
          children: [
            const InfoCard(name: "Name Surname", profession: "profession"),
            Padding(
              padding: const EdgeInsets.only(top: 32,left:24 ,bottom: 16),
              child: Text("Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70)),
            ),
            
            const SideMenuTile(),
          ],
        ),
      ),
    );
  }
}

class SideMenuTile extends StatelessWidget {
  const SideMenuTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.white24,
            height: 1,
          ),
        ),
        ListTile(
          onTap: () {},
          leading: SizedBox(
            height: 34,
            width: 34,
            child: RiveAnimation.asset(
              "assets/Rive_Animation/icons.riv",
              artboard: "HOME",
              onInit: (artboard) {},
            ),
          ),
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
