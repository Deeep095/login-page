import 'package:untitled1/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser?> get currentAuthUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
    required String role,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String role,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});

}
