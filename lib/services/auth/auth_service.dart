import 'package:untitled1/services/auth/firebase_auth_provider.dart';

import 'auth_user.dart';
import 'auth_provider.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;
  const AuthServices(this.provider);

  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  // @override
  // Future<AuthUser> logIn({
  //   required String email,
  //   required String password,
  // }) =>
  //     provider.logIn(
  //       email: email,
  //       password: password,
  //     );

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  static String? get_email_id() {
    return FirebaseAuthProvider.get_email_id();
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );
}
