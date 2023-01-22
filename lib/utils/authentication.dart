import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock/models/usuario.dart';
import 'package:stock/services/user_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

void signOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('id');
  prefs.remove('role');
}

Future signInWithGoogle() async {
  await Firebase.initializeApp();
  User? user;
  UsuarioModel? fullUser;

  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);

    user = userCredential.user;

    if (user != null) {
      fullUser = await UserService.getUsuario(user.uid);
      if (fullUser.id == null) {
        fullUser.id = user.uid;
        fullUser.nome = user.displayName;
        fullUser.email = user.email;
        fullUser.avatar = user.photoURL;
        fullUser.role = "comum";
        fullUser.dataCadastro = DateTime.now() as String?;
        await UserService.postUsuario(fullUser);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', fullUser.id ?? '');
      prefs.setString('role', fullUser.role ?? '');
    }
  } catch (error) {
    log("an error occured while getting product info $error");
    throw error.toString();
  }
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('id');
  prefs.remove('role');
}

Future<UserCredential> signInWithFacebook() async {
  await Firebase.initializeApp();

  FacebookAuthProvider facebookProvider = FacebookAuthProvider();

  facebookProvider.addScope('email');
  facebookProvider.setCustomParameters({
    'display': 'popup',
  });

  return await FirebaseAuth.instance.signInWithPopup(facebookProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
}

Future<UserCredential> signInWithTwitter() async {
  await Firebase.initializeApp();

  TwitterAuthProvider twitterProvider = TwitterAuthProvider();

  return await FirebaseAuth.instance.signInWithPopup(twitterProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(twitterProvider);
}
