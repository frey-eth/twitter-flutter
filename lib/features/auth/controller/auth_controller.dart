import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/APIs/auth_api.dart';
import 'package:twitter/APIs/user_api.dart';
import 'package:twitter/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:twitter/features/auth/view/login_view.dart';
import 'package:twitter/features/home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    return AuthController(
        authAPI: ref.watch(authAPIProvider),
        userAPI: ref.watch(userAPIProvider));
  },
);

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state : isLoading
  Future<model.User?> currentUser() => _authAPI.currentUserAccount();
  // _account.get() != null ? HomeView : Login
  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
            email: email,
            name: getNameFromEmail(email),
            followers: [],
            following: [],
            profilePic: '',
            bannerPic: '',
            uid: r.$id,
            bio: '',
            isTwitterBlue: false);
        final res = await _userAPI.saveUserData(userModel);
        res.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Account has been created');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.router());
      },
    );
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final document = await _userAPI.getUserData(uid);
      final updatedUser = UserModel.fromMap(document.data);
      return updatedUser;
    } on AppwriteException catch (e) {
      print('Error fetching user data: ${e.message}');
      return null; // Return null or handle the error appropriately
    }
  }
}
