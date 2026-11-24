import 'package:firebase_auth/firebase_auth.dart';

/// Turns any error thrown during login / register / reset into a message a
/// student can understand, instead of "[firebase_auth/invalid-credential] ...".
String friendlyAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-login-credentials':
        return 'Incorrect email or password. Please try again.';
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact the exam office.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few minutes and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this app yet.';
      case 'missing-email':
        return 'Please enter your email.';
      default:
        return 'Something went wrong (${error.code}). Please try again.';
    }
  }
  final text = error.toString().replaceAll('Exception: ', '');
  return text.isEmpty ? 'Something went wrong. Please try again.' : text;
}
