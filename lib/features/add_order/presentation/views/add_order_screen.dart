import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracker_app/core/routing/app_routes.dart';
import 'package:order_tracker_app/core/styling/app_assets.dart';
import 'package:order_tracker_app/core/styling/app_colors.dart';
import 'package:order_tracker_app/core/styling/app_styles.dart';
import 'package:order_tracker_app/core/widgets/custom_text_field.dart';
import 'package:order_tracker_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracker_app/core/widgets/spacing_widgets.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final orderIDController = TextEditingController();
    final orderNameController = TextEditingController();
    final orderArrivalTimeController = TextEditingController();
    LatLng? orderLocation;
    String? orderPlace;
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
      body: Padding(
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
                const HeightSpace(30),
                PrimayButtonWidget(
                  icon: Icon(Icons.location_on_outlined, color: Colors.white),
                  buttonText: "Select Directions",
                  onPress: () {
                    context.pushNamed(AppRoutes.palcePikerScreen);
                  },
                ),
                const HeightSpace(16),
                PrimayButtonWidget(buttonText: "Add Order", onPress: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
