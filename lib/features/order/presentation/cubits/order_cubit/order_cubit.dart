import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracker_app/features/order/data/model/order_model.dart';
import 'package:order_tracker_app/features/order/data/repo/order_repo.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.orderRepo}) : super(OrderInitial());
  final OrderRepo orderRepo;

  Future<void> addOrder({required OrderModel orderModel}) async {
    emit(OrderAddingStatus());
    final result = await orderRepo.addOrder(orderModel: orderModel);
    result.fold(
      (error) => emit(OrderAddedError(error)),
      (success) => emit(OrderAddedSuccess(success)),
    );
  }
}
