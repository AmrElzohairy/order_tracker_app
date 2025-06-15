import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracker_app/core/styling/app_colors.dart';
import 'package:order_tracker_app/core/styling/app_styles.dart';
import 'package:order_tracker_app/core/widgets/loading_widget.dart';
import 'package:order_tracker_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracker_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracker_app/features/order/presentation/cubits/order_cubit/order_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    context.read<OrderCubit>().getUserOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Orders",
          style: AppStyles.primaryHeadLinesStyle.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is GetUserOrdersLoading) {
            return LoadingWidget();
          }
          if (state is GetUserOrdersError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is GetUserOrdersSuccess) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "order id:#${state.orders[index].orderId}",
                          style: AppStyles.black18BoldStyle,
                        ),
                        Text(
                          "order name: ${state.orders[index].orderName}",
                          style: AppStyles.black18BoldStyle,
                        ),
                        Text(
                          "order arrival time: ${state.orders[index].orderDate}",
                          style: AppStyles.black15BoldStyle,
                        ),
                        Text(
                          "order status: ${state.orders[index].orderStatus}",
                          style: AppStyles.black15BoldStyle.copyWith(
                            color: Colors.green,
                          ),
                        ),
                        HeightSpace(10),
                        PrimayButtonWidget(
                          buttonText: "Track Order",
                          onPress: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
