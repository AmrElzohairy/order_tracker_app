import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracker_app/features/order/data/model/order_model.dart';

class OrderRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<String, String>> addOrder({
    required OrderModel orderModel,
  }) async {
    try {
      await firestore.collection("orders").doc().set(orderModel.toJson());
      return const Right("Order Added Successfully");
    } catch (e) {
      return Left("Error when adding order $e");
    }
  }

  Future<Either<String, List<OrderModel>>> getUserOrders() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore
              .collection("orders")
              .where(
                "orderUserId",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .get();
      List<OrderModel> orders =
          snapshot.docs
              .map((order) => OrderModel.fromJson(order.data()))
              .toList();
      return Right(orders);
    } catch (e) {
      return Left("Error when getting user orders $e");
    }
  }

  Future<Either<String, String>> editUserLocactionAndStatus({
    required String orderId,
    required double userLat,
    required double userLong,
  }) async {
    try {
      await firestore
          .collection("orders")
          .where("orderId", isEqualTo: orderId)
          .get()
          .then((value) {
            value.docs.first.reference.update({
              "userLat": userLat,
              "userLong": userLong,
              "orderStatus": "On The Way",
            });
          });
      return const Right("User Location Updated Successfully");
    } catch (e) {
      return Left("Erro when updating user location $e");
    }
  }
}
