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
