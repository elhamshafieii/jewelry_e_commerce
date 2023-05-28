import 'package:flutter/material.dart';
import 'package:jewelry_e_commerce/data/data_source/auth_data_source.dart';
import 'package:jewelry_e_commerce/model/auth_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(dataSource: AuthFirebaseDataSource());

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});
  @override
  Future<void> login(String username, String password) async {
    final credential = await dataSource.login(username, password);
    _persistAuthInfo(credential);
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(String username, String password) async {
    final authInfo = await dataSource.signUp(username, password);
    _persistAuthInfo(authInfo);
  }

  Future<AuthInfo> _persistAuthInfo(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('uid', authInfo.uid);
    return loadAuthInfo();
  }

  Future<AuthInfo> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String uid = sharedPreferences.getString('uid') ?? '';
    if (uid.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(uid: uid);
    }
    return AuthInfo(uid: uid);
  }
}
