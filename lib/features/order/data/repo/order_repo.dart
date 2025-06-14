import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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
}
