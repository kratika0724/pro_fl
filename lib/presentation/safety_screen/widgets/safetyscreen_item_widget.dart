import '../models/safetyscreen_item_model.dart';
import '../controller/safety_controller.dart';
import 'package:flutter/material.dart';
import 'package:family_location_app/core/app_export.dart';

// ignore: must_be_immutable
class SafetyscreenItemWidget extends StatelessWidget {
  SafetyscreenItemWidget(
    this.safetyscreenItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  SafetyscreenItemModel safetyscreenItemModelObj;

  var controller = Get.find<SafetyController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 19.v,
      ),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.only(left: 4.h),
            decoration: AppDecoration.fillPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder6,
            ),
            child: Obx(
              () => CustomImageView(
                imagePath: safetyscreenItemModelObj.crashdetection!.value,
                height: 20.adaptSize,
                width: 20.adaptSize,
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Obx(
              () => Text(
                safetyscreenItemModelObj.mother!.value,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          Spacer(),
          Obx(
            () => CustomImageView(
              imagePath: safetyscreenItemModelObj.crashdetection1!.value,
              height: 24.adaptSize,
              width: 24.adaptSize,
            ),
          ),
        ],
      ),
    );
  }
}
