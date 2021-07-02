import 'package:firebase_auth/firebase_auth.dart';
import 'package:sail_live_mobile/models/user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  SailLiveUser _userFromUser(User user) {
    return user != null ? SailLiveUser(uid: user.uid, email: user.email) : null;
  }

  Stream<SailLiveUser> get user {
    return _auth.authStateChanges().map(_userFromUser);
  }

  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(result.user);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
