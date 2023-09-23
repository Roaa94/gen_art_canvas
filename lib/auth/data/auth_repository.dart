import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> watchUser() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signInAnonymously() async {
    final credentials = await _auth.signInAnonymously();
    return credentials.user;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);
