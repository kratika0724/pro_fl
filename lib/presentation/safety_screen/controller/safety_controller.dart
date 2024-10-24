import '../../../core/app_export.dart';
import '../models/safety_model.dart';
import 'package:flutter/material.dart';

/// A controller class for the SafetyScreen.
///
/// This class manages the state of the SafetyScreen, including the
/// current safetyModelObj
class SafetyController extends GetxController {
  TextEditingController checkmarkController = TextEditingController();

  Rx<SafetyModel> safetyModelObj = SafetyModel().obs;

  Rx<bool> isSelectedSwitch = false.obs;

  RxInt isSelected = 0.obs;

  @override
  void onClose() {
    super.onClose();
    checkmarkController.dispose();
  }
}
