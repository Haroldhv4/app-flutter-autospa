import 'package:flutter/material.dart';
import 'package:flutter_autotalleres/presentation/screens/login_screen.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routename = 'WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(
              height: 696.h,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      height: 538.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgImage27,
                            height: 538.h,
                            width: double.maxFinite,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 28.h,
                              width: 94.h,
                              margin: EdgeInsets.only(
                                left: 42.h,
                                bottom: 186.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 250.h,
                    margin: EdgeInsets.only(
                      left: 28.h,
                      bottom: 88.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Taller de Pintura",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displaySmall!.copyWith(
                            height: 1.20,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Detallado con precisión para conductores que valoran la perfección.",
                          style: theme.textTheme.bodyMedium,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildCallToAction(context),
    );
  }

  /// Section Widget
  Widget _buildCallToAction(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 28.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "Comenzar Ahora",
            margin: EdgeInsets.only(bottom: 18.h),
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.routename);
            },
          )
        ],
      ),
    );
  }
}
