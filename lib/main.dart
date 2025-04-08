//
// import 'dart:js_interop';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Views/ClassHomeScreen.dart';
import 'package:untitled1/Views/ClassInsides/UploadArea.dart';
import 'package:untitled1/Views/HomeScreen.dart';
import 'package:untitled1/Views/Extras/LoginView.dart';
import 'package:untitled1/Views/Extras/RegisterView.dart';
import 'package:untitled1/Views/ShowAddClassDialog.dart';
import 'package:untitled1/Views/VerifyEmailView.dart';
import 'package:untitled1/services/auth/auth_service.dart';
import 'dart:developer' as devtools
    show log; // personalizing the log in-build function as devtools.log
import 'Constants/routes.dart';
import 'Views/ClassInfoProvider.dart';
import 'Views/OnBoardingScreen.dart';
import 'Views/notes_view.dart';
// import 'package:google_api_availability/google_api_availability.dart';
// import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  AuthServices.firebase().initialize();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Cloud app',
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: ChangeNotifierProvider(
      create: (context) => ClassInfoProvider(),
      child:
          const MyApp(), // Make sure MyApp (and HomeScreen inside it) is wrapped with the provider
    ),
  ));
  // runApp(
  //     MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   title: 'First app',
  //   theme: ThemeData(
  //     primarySwatch: Colors.lightBlue,
  //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //     useMaterial3: true,
  //   ),
  //   home: const OnBoardingScreen(), // Add this line to specify the home screen
  //
  //   routes: {
  //     loginRoute: (context) => const LoginView(),
  //     registerRoute: (context) => const RegisterView(),
  //     verifyEmailRoute: (context) => const VerifyEmailView(''),
  //     notesRoute: (context) => const NotesView(),
  //     homeScreenRoute: (context) => const HomeScreen(),
  //     classHomeScreenRoute: (context) => const ClassHomeScreen(
  //           classNumber: '',
  //           classSection: '',
  //           classSubject: '',
  //           classMonitor: '',
  //         ),
  //     showAddClassDialogRoute: (context) => const showAddClassDialog(),
  //     onBoardingScreenRoute: (context) => const OnBoardingScreen(),
  //   },
  //
  // ),
  //
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First app',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnBoardingScreen(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(''),
        notesRoute: (context) => const NotesView(),
        homeScreenRoute: (context) => const HomeScreen(),
        classHomeScreenRoute: (context) => const ClassHomeScreen(
              classNumber: '',
              classSection: '',
              classSubject: '',
              classMonitor: '',
            ),
        uploadAreaRoute: (context) => const UploadArea(),
        showAddClassDialogRoute: (context) => const showAddClassDialog(),
        onBoardingScreenRoute: (context) => const OnBoardingScreen(),
      }, // HomeScreen is a descendant of the provider
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user == null) {
              print("ERORR@@@@@@@");
            }
            if (user != null) {
              final String? userEmail = AuthServices
                  .get_email_id(); //? if user is not there // ?? if it is not assigned any value true or false then take false for instance
              if (user.isEmailVerified) {
                devtools.log("Email is Verified");
                return const NotesView();
              } else {
                return VerifyEmailView(userEmail ?? 'null');
              }
            } else {
              return const LoginView();
            }

          default: //waiting state
            return const CircularProgressIndicator();
        }
      },
      future: null,
    );
  }
}
