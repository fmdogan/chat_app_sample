import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/dataproviders/user_providers.dart';
import 'package:bloc_chat/data/repositories/user_repo.dart';
import 'package:bloc_chat/presentation/widgets/auth_error_dialog.dart';
import 'package:bloc_chat/services/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  FirebaseAuthService authService = new FirebaseAuthService();
  UserRepo _userRepo = UserRepo();

  void signIn(BuildContext context) async {
    emit(AuthLoading());

    await authService.signInWithGoogle().then((_userCredential) async {
      print('Signed-in User: ' + _userCredential.user!.uid);
      String name = _userCredential.user!.displayName!.isNotEmpty ? _userCredential.user!.displayName! : '';

      /// here we store user data on firestore beside firebase auth mechanism if the user is new
      await _userRepo.getUser(uid: _userCredential.user!.uid).then(
        (_userData) async {
          if (_userData.id == '') {
            // must return a user to loggedUser...
            await _userRepo.createUser(user: User(id: _userCredential.user!.uid, name: name)).then((_user) {
              loggedUser = _user;
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            });
          } else {
            await _userRepo.getUser(uid: _userCredential.user!.uid).then((_user) {
              loggedUser = _user;
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            });
          }
        },
      );

      ///
      emit(AuthInitial());
    }).onError((error, stackTrace) {
      emit(AuthInitial());
      showMessage(context, error.toString());
    });
  }

  void signOut(BuildContext context) async {
    Navigator.pushReplacementNamed(context, '/');
    emit(AuthLoading());
    await authService.signOutFromGoogle().whenComplete(() {
      emit(AuthInitial());
    });
  }
}
