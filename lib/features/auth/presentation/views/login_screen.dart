import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracker_app/core/routing/app_routes.dart';
import 'package:order_tracker_app/core/styling/app_assets.dart';
import 'package:order_tracker_app/core/styling/app_colors.dart';
import 'package:order_tracker_app/core/styling/app_styles.dart';
import 'package:order_tracker_app/core/widgets/custom_text_field.dart';
import 'package:order_tracker_app/core/widgets/loading_widget.dart';
import 'package:order_tracker_app/core/widgets/primay_button_widget.dart';
import 'package:order_tracker_app/core/widgets/spacing_widgets.dart';
import 'package:order_tracker_app/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

import '../../../../core/utils/animated_snack_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController username;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();

    username = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              showAnimatedSnackDialog(
                context,
                message: state.errMessage,
                type: AnimatedSnackBarType.error,
              );
            }
            if (state is AuthSuccess) {
              showAnimatedSnackDialog(context, message: "Login successful");
              context.go(AppRoutes.homeScreen);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoadingWidget();
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(28),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "Login To Your Account",
                          style: AppStyles.primaryHeadLinesStyle,
                        ),
                      ),
                      const HeightSpace(8),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "it's great to see you again",
                          style: AppStyles.grey12MediumStyle,
                        ),
                      ),
                      const HeightSpace(20),
                      Center(
                        child: Image.asset(
                          AppAssets.order,
                          width: 190.w,
                          height: 190.w,
                        ),
                      ),
                      const HeightSpace(32),
                      Text("User Name", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: username,
                        hintText: "Enter Your User Name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your User Name";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(16),
                      Text("Password", style: AppStyles.black16w500Style),
                      const HeightSpace(8),
                      CustomTextField(
                        hintText: "Enter Your Password",
                        controller: password,
                        suffixIcon: Icon(
                          Icons.remove_red_eye,
                          color: AppColors.greyColor,
                          size: 20.sp,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(55),
                      PrimayButtonWidget(
                        buttonText: "Sign in",
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              email: username.text,
                              password: password.text,
                            );
                          }
                        },
                      ),
                      const HeightSpace(16),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoutes.registerScreen);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: AppStyles.black16w500Style.copyWith(
                                color: AppColors.secondaryColor,
                              ),
                              children: [
                                TextSpan(
                                  text: "Join",
                                  style: AppStyles.black15BoldStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const HeightSpace(16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
