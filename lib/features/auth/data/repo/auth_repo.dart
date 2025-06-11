import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracker_app/features/auth/data/models/user_model.dart';

class AuthRepo {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<String, String>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await firestore.collection("users").doc(userCredential.user!.uid).set({
        "username": username,
        "email": email,
        "uid": userCredential.user!.uid,
      });
      log("Register Successfully");
      return const Right("Account Created Successfully");
    } catch (e) {
      log("Error in register user in auth repo => $e");
      return Left("Error when creating user $e");
    }
  }

  Future<Either<String, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore
              .collection("users")
              .where("uid", isEqualTo: userCredential.user!.uid)
              .get();
      log("snapshot => ${snapshot.docs.first.data()}");
      final userJson = snapshot.docs.first.data();
      final user = UserModel.fromJson(userJson);
      log("Login Successfully");
      return Right(user);
    } catch (e) {
      log("Error in login user in auth repo => $e");
      return Left("Error when login $e");
    }
  }
}
