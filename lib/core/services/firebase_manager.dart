import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_clinic/core/constant.dart';
import 'package:crm_clinic/core/services/collections.dart';
import 'package:crm_clinic/data/model/appointment_model.dart';
import 'package:crm_clinic/data/model/doctor/available_slot_model.dart';
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
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
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
      return await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential,
      );
    } else {
      // Handle login failure or cancellation
      throw FirebaseAuthException(
        code: loginResult.status.toString(),
        message: loginResult.message ?? "Facebook login failed",
      );
    }
  }

  Future<void> addUser({
    required UserModel userModel,
    required UserCredential userCredential,
  }) async {
    String uid = userCredential.user!.uid;
    await _db.collection(Collections.users).doc(uid).set({
      'fullName': userModel.fullName,
      'email': userModel.email,
      'permission': userModel.permission,
      'joined': userModel.joined,
      'uid': uid,
    });
  }

  Future<void> addPatient(PatientModel patientModel) async {
    final docRef = _db.collection(Collections.patients).doc();
    patientModel.patientId = docRef.id;
    await docRef.set(patientModel.toJson());
  }

  Future<void> removeDoc({
    required String collection,
    required String id,
  }) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllDocsInCollection(
    String collectionPath,
  ) {
    final collectionRef = _db.collection(collectionPath);
    return collectionRef.snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDoctors() {
    return _db
        .collection(Collections.users)
        .where('permission', isEqualTo: UserPermission.doctor.value)
        .get();
  }

  Future<UserPermission> getUserPermission(String uid) async {
    try {
      final docSnapshot = await _db
          .collection(Collections.users)
          .doc(uid)
          .get();
      final userData = docSnapshot.data();
      final String role = (userData?['permission'] ?? '')
          .toString()
          .toLowerCase();
      log("role =$role  /  admin permission : ${UserPermission.admin.name}");

      // توجيه حسب الـ role
      if (role == UserPermission.admin.value.toLowerCase()) {
        return UserPermission.admin;
      } else if (role == UserPermission.doctor.value.toLowerCase()) {
        return UserPermission.doctor;
      } else if (role == UserPermission.nurse.value.toLowerCase()) {
        return UserPermission.nurse;
      } else if (role == UserPermission.receptionist.value.toLowerCase()) {
        return UserPermission.receptionist;
      } else {
        log("Unknown role: $role");
        throw Exception("Unknown role: $role");
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
          .collection(Collections.users)
          .where('permission', isEqualTo: UserPermission.admin.value)
          .limit(1)
          .get();

      log("found admin ${query.docs.length}");

      if (query.docs.isEmpty) {
        // 2. محاولة تسجيل دخول أو إنشاء حساب admin
        UserCredential userCredential = await registerService(
          Constant.adminEmail,
          Constant.adminPassword,
        );

        final adminUid = userCredential.user!.uid;

        log("created admin and uid: $adminUid");
        // 3. إضافة بيانات admin في Firestore

        await addUser(
          userModel: UserModel(
            email: Constant.adminEmail,
            fullName: 'Admin',
            joined: DateTime.now(),
            permission: UserPermission.admin.value,
            uid: adminUid,
          ),
          userCredential: userCredential,
        );
      } else {
        log("admin already exists");
        throw Exception("Admin already exists.");
      }
    } catch (e) {
      log("❌ Error creating admin: $e");
      throw Exception("❌ Error creating admin: $e");
    }
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _db.collection(Collections.appointments).add(appointment.toJson());
  }

  Stream<List<AppointmentModel>> getAppointmentsByDate(
    DateTime date,
    String doctorId,
  ) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    return _db
        .collection(Collections.appointments)
        .where('doctorId', isEqualTo: doctorId)
        .where('dateTime', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('dateTime', isLessThan: end.toIso8601String())
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateAppointment(String id, DateTime newDate) async {
    await _db.collection(Collections.appointments).doc(id).update({
      'dateTime': newDate.toIso8601String(),
    });
  }

  Future<void> cancelAppointment(String id) async {
    await _db.collection(Collections.appointments).doc(id).update({
      'status': 'canceled',
    });
  }

  // -- دالة للطبيب لإضافة مواعيده المتاحة --
  // سيستخدمها الطبيب من شاشته الخاصة لتحديد أوقاته
  Future<void> addAvailableSlotsForDoctor({
    required String doctorId,
    required List<DateTime> slots,
  }) async {
    final batch = _db.batch(); // استخدام batch للكتابة المجمعة لزيادة الكفاءة
    final doctorSlotsCollection = _db
        .collection(Collections.users)
        .doc(doctorId)
        .collection('availableSlots');

    for (final slotTime in slots) {
      final slotDoc = doctorSlotsCollection.doc();
      batch.set(
        slotDoc,
        AvailableSlotModel(
          startTime: slotTime,
          status: 'available',
          id: slotDoc.id,
        ).toJson(),
      );
    }
    await batch.commit();
    log("Added ${slots.length} new available slots for doctor $doctorId");
  }

  // -- دالة لجلب المواعيد المتاحة لطبيب معين --
  // سيستخدمها موظف الاستقبال في شاشة الحجز
  Future<QuerySnapshot<Map<String, dynamic>>> getAvailableSlotsForDoctor(
    String doctorId,
  ) {
    return _db
        .collection(Collections.users)
        .doc(doctorId)
        .collection(Collections.availableSlots)
        .where('status', isEqualTo: 'available') // جلب المواعيد المتاحة فقط
        .orderBy('startTime') // ترتيبها زمنياً
        .get();
  }

  // -- دالة لحجز الموعد وتحديث حالته (الأهم) --
  // هذه الدالة تضمن عدم حجز الموعد مرتين في نفس اللحظة
  Future<void> bookAppointmentAndUpdateSlot({
    required String patientId,
    required String doctorId,
    required String slotId, // ID الخاص بالموعد المتاح
    required PatientModel patient, // نحتاج لبيانات المريض
  }) async {
    final slotRef = _db
        .collection(Collections.users)
        .doc(doctorId)
        .collection(Collections.availableSlots)
        .doc(slotId);
    final appointmentRef = _db.collection(Collections.appointments).doc();

    return _db
        .runTransaction((transaction) async {
          // 1. اقرأ بيانات الموعد المتاح أولاً
          final slotSnapshot = await transaction.get(slotRef);

          if (!slotSnapshot.exists ||
              slotSnapshot.data()?['status'] != 'available') {
            throw Exception("This slot is no longer available!");
          }

          final slotData = slotSnapshot.data()!;
          final appointmentTime = (slotData['startTime'] as Timestamp).toDate();

          // 2. قم بتحديث حالة الموعد المتاح إلى "محجوز"
          transaction.update(slotRef, {'status': 'booked'});

          // 3. قم بإنشاء الحجز الجديد في مجموعة appointments
          final newAppointment = AppointmentModel(
            id: appointmentRef.id,
            patientId: patientId,
            doctorId: doctorId,
            dateTime: appointmentTime,
            patientName: patient.fullName,
            patientPhone: patient.phone,
            status: 'booked',
          );
          transaction.set(appointmentRef, newAppointment.toJson());

          log("Transaction successful: Appointment booked and slot updated.");
        })
        .catchError((error) {
          log("Transaction failed: $error");
          throw Exception("Failed to book appointment. Please try again.");
        });
  }
}
