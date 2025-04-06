import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/firebase_options.dart';
import 'package:untitled1/services/auth/auth_service.dart';

import 'auth_user.dart';
import 'auth_provider.dart';
import 'auth_excepions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;

class FirebaseAuthProvider implements AuthProvider {
  int ID_incrementer = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user2 = FirebaseAuth.instance.currentUser;
      if (user2 != null) {
        // Save the user's role in Firestore

        ID_incrementer++;
        await _firestore.collection("users").doc(user2.uid).set({
          'id': ID_incrementer,
          'email': email,
          'password': password,
          'role': role,
        });
        print("email = $email   role = $role");
        // Return the created user with the role
        return AuthUser(
          id: user2.uid,
          email: user2.email as String,
          isEmailVerified: user2.emailVerified,
          role: role, // Pass the role as an argument
        );
      } else {
        throw UsrNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyinUseException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Fetch role from Firestore
      return AuthUser.fromFirebase(firebaseUser, role: 'student');
    }
    return null;
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //
    //   // Fetch the role from Firestore
    //   return _getUserFromFirebase(user) as AuthUser;
    // } else {
    //   return null;
    // }
  }

  @override
  Future<AuthUser?> get currentAuthUser async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Fetch role from Firestore
      String role = await getUserRole(firebaseUser.uid);
      return AuthUser.fromFirebase(firebaseUser, role: role);
    }
    return null;
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //
    //   // Fetch the role from Firestore
    //   return _getUserFromFirebase(user) as AuthUser;
    // } else {
    //   return null;
    // }
  }

  Future<String> getUserRole(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists
        ? userDoc['role'] as String
        : 'student'; // Default to student
  }

  static String? get_email_id() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email.toString();
    }
    return null;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final user2 = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = user2.user;

      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final fetchedRole =
            userDoc.data()?['role'] ?? 'student'; // Default to 'student'

        print("Fetched role from Firestore: $fetchedRole");

        // Pass the role to the AuthUser constructor and return
        return AuthUser.fromFirebase(user, role: fetchedRole);
      } else {
        throw UsrNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      }
      // else if (e.code == 'user-disabled') {
      //
      // }
      // else if (e.code == 'invalid-credential') {
      //
      // }
      else {
        print("                   e.code          ===== ${e.code}");
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Future<void> logOut() async {
      await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UsrNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
