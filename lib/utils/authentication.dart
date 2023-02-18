import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock/models/usuario.dart';
import 'package:stock/services/user_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void signOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('id');
  prefs.remove('role');
  prefs.remove('avatar');
  if (prefs.getString('login') != 'email') {
    await _auth.signOut();
  }
  prefs.remove('login');
}

Future signInWithGoogle() async {
  await Firebase.initializeApp();
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);

    await inicializarUsuario(userCredential, 'google');
  } catch (error) {
    log("an error occured while login google info $error");
    throw error.toString();
  }
}

Future signInWithFacebook() async {
  await Firebase.initializeApp();
  FacebookAuthProvider facebookProvider = FacebookAuthProvider();

  facebookProvider.addScope('email');
  facebookProvider.setCustomParameters({
    'display': 'popup',
  });

  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(facebookProvider);

    await inicializarUsuario(userCredential, 'facebook');
  } catch (error) {
    log("an error occured while login facebook info $error");
    throw error.toString();
  }
}

Future signInWithTwitter() async {
  await Firebase.initializeApp();

  TwitterAuthProvider twitterProvider = TwitterAuthProvider();

  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(twitterProvider);

    await inicializarUsuario(userCredential, 'twitter');
  } catch (error) {
    log("an error occured while login twitter info $error");
    throw error.toString();
  }
}

Future inicializarUsuario(userCredential, tipoLogin) async {
  User? user;
  UsuarioModel? fullUser;
  user = userCredential.user;

  fullUser = await UserService.getUsuario(user!.uid);
  if (fullUser.id == null) {
    fullUser.id = user.uid;
    fullUser.nome = user.displayName;
    fullUser.email = user.email;
    fullUser.avatar = user.photoURL;
    fullUser.role = "comum";
    await UserService.postUsuario(fullUser);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('id', fullUser.id ?? '');
  prefs.setString('role', fullUser.role ?? '');
  prefs.setString('login', tipoLogin ?? '');
  prefs.setString('avatar', fullUser.avatar ?? '');
}
