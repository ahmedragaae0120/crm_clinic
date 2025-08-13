import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/constant.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/data/model/patient_model.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseManager {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

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
      'joined': userModel.joined,
      'uid': uid
    });
  }

  Future<void> addPatient(PatientModel patientModel) async {
    final docRef = _db.collection(Collections.patients).doc();
    patientModel.uid = docRef.id;
    await docRef.set(patientModel.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    final collectionRef = _db.collection(Collections.users);
    return collectionRef.snapshots();
  }

  Future<UserPermission> getUserPermission(String uid) async {
    try {
      final docSnapshot =
          await _db.collection(Collections.users).doc(uid).get();
      final userData = docSnapshot.data();
      final String? role = userData?['permission'] ?? '';

      // توجيه حسب الـ role
      if (role == UserPermission.admin.name) {
        return UserPermission.admin;
      } else if (role == UserPermission.doctor.name) {
        return UserPermission.doctor;
      } else if (role == UserPermission.nurse.name) {
        return UserPermission.nurse;
      } else {
        return UserPermission.receptionist;
      }
    } catch (e) {
      log('Error fetching role: $e');
      throw Exception('Error fetching role: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// دالة خاصة لإنشاء admin إذا لم يكن موجود
  Future<void> createDefaultAdminIfNotExists() async {
    try {
      // 1. البحث عن admin في Firestore
      final query = await _db
          .collection('users')
          .where('permission', isEqualTo: 'Admin')
          .limit(1)
          .get();

      log("found admin ${query.docs.length}");

      if (query.docs.isEmpty) {
        // 2. محاولة تسجيل دخول أو إنشاء حساب admin
        UserCredential userCredential =
            await registerService(Constant.adminEmail, Constant.adminPassword);

        final adminUid = userCredential.user!.uid;

        log("created admin and uid: $adminUid");
        // 3. إضافة بيانات admin في Firestore

        await addUser(
            userModel: UserModel(
              email: Constant.adminEmail,
              fullName: 'Admin',
              joined: DateTime.now(),
              permission: UserPermission.admin.name,
              uid: adminUid,
            ),
            userCredential: userCredential);
      } else {
        log("admin already exists");
        throw Exception("Admin already exists.");
      }
    } catch (e) {
      log("❌ Error creating admin: $e");
      throw Exception("❌ Error creating admin: $e");
    }
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
