import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracker_app/core/routing/app_routes.dart';
import 'package:order_tracker_app/core/styling/app_assets.dart';
import 'package:order_tracker_app/core/styling/app_colors.dart';
import 'package:order_tracker_app/core/styling/app_styles.dart';
import 'package:order_tracker_app/core/utils/animated_snack_dialog.dart';
import 'package:order_tracker_app/core/widgets/custom_text_field.dart';
import 'package:order_tracker_app/core/widgets/loading_widget.dart';
import 'package:order_tracker_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracker_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracker_app/features/order/data/model/order_model.dart';
import 'package:order_tracker_app/features/order/presentation/cubits/order_cubit/order_cubit.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final formKey = GlobalKey<FormState>();
  final orderIDController = TextEditingController();
  final orderNameController = TextEditingController();
  final orderArrivalTimeController = TextEditingController();
  LatLng? orderLocation;
  String orderLocationDetails = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: const Text(
          "Add Order",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderAddedError) {
            showAnimatedSnackDialog(
              context,
              message: state.errMessage,
              type: AnimatedSnackBarType.error,
            );
          }
          if (state is OrderAddedSuccess) {
            showAnimatedSnackDialog(context, message: state.successMessage);
            orderIDController.clear();
            orderNameController.clear();
            orderArrivalTimeController.clear();
            orderLocation = null;
          }
        },
        builder: (context, state) {
          if (state is OrderAddingStatus) {
            return const LoadingWidget();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        AppAssets.order,
                        width: 190.w,
                        height: 190.w,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("Order ID", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: orderIDController,
                      hintText: "Enter Order ID",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Order ID is required";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(32),
                    Text("Order Name", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: orderNameController,
                      hintText: "Enter Order Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Order Name is required";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(32),
                    Text("Order Arrival", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      readOnly: true,
                      controller: orderArrivalTimeController,
                      hintText: "Enter Order Date",
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        ).then((value) {
                          orderArrivalTimeController.text =
                              "${value!.day}/${value.month}/${value.year}";
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Order Date is required";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(32),
                    Text("Order Location", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      readOnly: true,
                      controller: null,
                      hintText:
                          orderLocationDetails.isNotEmpty
                              ? orderLocationDetails
                              : "Select Location From Map",
                    ),
                    const HeightSpace(30),
                    PrimayButtonWidget(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      buttonText: "Select Location",
                      onPress: () async {
                        LatLng? latlng = await context.push<LatLng?>(
                          AppRoutes.palcePikerScreen,
                        );
                        if (latlng != null) {
                          orderLocation = latlng;
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                orderLocation!.latitude,
                                orderLocation!.longitude,
                              );
                          orderLocationDetails =
                              "${placemarks.first.country}, ${placemarks.first.locality}, ${placemarks.first.street}";
                        }
                        setState(() {});
                      },
                    ),
                    const HeightSpace(16),
                    PrimayButtonWidget(
                      buttonText: "Create Order",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          if (orderLocation == null) {
                            showAnimatedSnackDialog(
                              context,
                              message: "Please Select Order Location",
                              type: AnimatedSnackBarType.warning,
                            );
                            return;
                          }
                          OrderModel orderModel = OrderModel(
                            orderId: orderIDController.text,
                            orderName: orderNameController.text,
                            orderLat: orderLocation!.latitude,
                            orderLong: orderLocation!.longitude,
                            orderDate: orderArrivalTimeController.text,
                            orderStatus: "Pending",
                            userLat: 0.0,
                            userLong: 0.0,
                            orderUserId: FirebaseAuth.instance.currentUser!.uid,
                          );
                          context.read<OrderCubit>().addOrder(
                            orderModel: orderModel,
                          );
                        }
                      },
                    ),
                    const HeightSpace(20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
