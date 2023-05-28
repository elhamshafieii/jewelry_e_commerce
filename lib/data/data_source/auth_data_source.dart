import 'package:firebase_auth/firebase_auth.dart';
import 'package:jewelry_e_commerce/data/common.dart';
import 'package:jewelry_e_commerce/model/auth_info.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> signUp(String username, String password);
}

class AuthFirebaseDataSource implements IAuthDataSource {
  final FirebaseAuth instance = FirebaseAuth.instance;

  @override
  Future<AuthInfo> login(String username, String password) async {
    UserCredential userCredential = await instance.signInWithEmailAndPassword(
        email: username, password: password);
    return AuthInfo(uid: userCredential.user!.uid);
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    UserCredential userCredential = await instance
        .createUserWithEmailAndPassword(email: username, password: password);
    final String uid = userCredential.user!.uid;
    database
        .collection('user')
        .doc(uid)
        .set({'username': username, 'password': password, 'cart': []});
    return login(username, password);
  }
}
