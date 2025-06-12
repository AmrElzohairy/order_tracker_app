import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracker_app/core/routing/app_routes.dart';
import 'package:order_tracker_app/core/styling/app_colors.dart';
import 'package:order_tracker_app/core/styling/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Home",
          style: AppStyles.primaryHeadLinesStyle.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
        ),
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Orders",
                  style: AppStyles.primaryHeadLinesStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.pushNamed(AppRoutes.addOrderScreen);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Add Order",
                  style: AppStyles.primaryHeadLinesStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
