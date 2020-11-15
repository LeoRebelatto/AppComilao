//import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class ModeloUsuario extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> streamUser = FirebaseAuth.instance.onAuthStateChanged;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isAdmin = false;

  bool isLoading = false;

  static ModeloUsuario of(BuildContext context) =>
      ScopedModel.of<ModeloUsuario>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    var user = await _auth.createUserWithEmailAndPassword(
        email: userData["email"], password: pass);

    userData['userId'] = user.user.uid;

    await _saveUserData(userData);

    onSuccess();
    isLoading = false;
    notifyListeners();
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    try {
      var user =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      // _auth
      //     .signInWithEmailAndPassword(email: email, password: pass)
      //     .then((user) async {

      //firebaseUser = user as FirebaseUser;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  bool verifyUserAdmin() {
    return isAdmin;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    //await Firestore.instance.collection('users').add(userData);
    await Firestore.instance
        .collection("users")
        .document(userData['userId'])
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
      await Firestore.instance
          .collection("admin")
          .document(firebaseUser.uid)
          .get()
          .then((doc) {
        if (doc.data != null) {
          isAdmin = true;
        } else {
          isAdmin = false;
        }
      }).catchError((e) {
        isAdmin = false;
      });
    }
    notifyListeners();
  }

  //entrar com facebook
  Future signInWithFacebook() async {
    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final AuthResult authResult =
            await _auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);

        return 'signInWithGoogle succeeded: $user';
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  //entrar com gmail
  Future signInWithGoogle() async {
    try {
      final GoogleSignIn signInWithGoogle = GoogleSignIn(
        scopes: ['email'],
        hostedDomain: "",
        clientId: "",
      );

      final GoogleSignInAccount googleUser = await signInWithGoogle.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return 'signInWithGoogle succeeded: $user';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void recuperarSenha(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
