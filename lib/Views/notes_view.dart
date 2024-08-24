
import 'package:flutter/material.dart';
import 'package:untitled1/services/auth/auth_service.dart';

import '../Constants/routes.dart';
import '../enums/menu_actions.dart';
import '../main.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  get devtools => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Main UI ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value)
              {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  // devtools.log(shouldLogout.toString());     //cannot use here
                  if(shouldLogout) {
                    await AuthServices.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("log out"),
                ),
              ];
            },
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are You Sure you want to SIGN OUT!!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out")),
          ],
        );
      }).then((value) => value ?? false);
}
