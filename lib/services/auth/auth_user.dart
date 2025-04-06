
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser{

  final String id;
  final String email;
  final bool isEmailVerified;
  final String role;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.role,
  });

  factory AuthUser.fromFirebase(User user,{required String role}) => AuthUser(
    id: user.uid,
    email: user.email!,
    isEmailVerified: user.emailVerified,
    role: role,

  );



}
