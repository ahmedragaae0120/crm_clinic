import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseManager {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserCredential> registerService(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginService(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId:
          '945797982425-kamkqj86p0lbplck77pme2uuq3hp8d7g.apps.googleusercontent.com',
    );
    final googleUser =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Check if the login was successful
    if (loginResult.status == LoginStatus.success &&
        loginResult.accessToken != null) {
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      // Sign in to Firebase with the Facebook credential
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } else {
      // Handle login failure or cancellation
      throw FirebaseAuthException(
        code: loginResult.status.toString(),
        message: loginResult.message ?? "Facebook login failed",
      );
    }
  }

  Future<void> addUser(
      {required UserModel userModel,
      required UserCredential userCredential}) async {
    String uid = userCredential.user!.uid;
    await _db.collection(Collections.users).doc(uid).set({
      'fullName': userModel.fullName,
      'email': userModel.email,
      'permission': userModel.permission,
      'joined': userModel.joined
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    final collectionRef = _db.collection(Collections.users);
    return collectionRef.snapshots();
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> getProducts() async {
  //   return await firestore.collection('menu').get();
  // }

  // Future<void> addToCart(ProductModel product) async {
  //   final user = auth.currentUser;
  //   if (user == null) throw Exception('User not logged in');
  //   return await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('cart')
  //       .doc(product.id)
  //       .set(product.toJson());
  // }

  // Future<List<ProductModel>> getCartItems() async {
  //   final user = auth.currentUser;
  //   if (user == null) throw Exception('User not logged in');

  //   final snapshot = await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('cart')
  //       .get();

  //   return snapshot.docs.map((doc) {
  //     return ProductModel.fromJson(doc.data(), doc.id);
  //   }).toList();
  // }

  // Future<void> removeFromCart(String productId) async {
  //   final user = auth.currentUser;
  //   if (user == null) {
  //     throw Exception('User not logged in');
  //   }

  //   return await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('cart')
  //       .doc(productId)
  //       .delete();
  // }
}
