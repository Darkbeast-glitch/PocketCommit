import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User> ensureSignedIn() async {
    final user = _auth.currentUser;
    if (user != null) return user;

    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  String get uid => _auth.currentUser!.uid;
}
