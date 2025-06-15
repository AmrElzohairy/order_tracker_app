part of 'order_cubit.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderAddingStatus extends OrderState {}

final class OrderAddedSuccess extends OrderState {
  final String successMessage;
  OrderAddedSuccess(this.successMessage);
}

final class OrderAddedError extends OrderState {
  final String errMessage;
  OrderAddedError(this.errMessage);
}

final class GetUserOrdersLoading extends OrderState {}

final class GetUserOrdersSuccess extends OrderState {
  final List<OrderModel> orders;
  GetUserOrdersSuccess(this.orders);
}

final class GetUserOrdersError extends OrderState {
  final String errMessage;
  GetUserOrdersError(this.errMessage);
}
