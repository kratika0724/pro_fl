import '../../../core/app_export.dart';
import 'safetyscreen_item_model.dart';

/// This class defines the variables used in the [safety_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class SafetyModel {
  Rx<List<SafetyscreenItemModel>> safetyscreenItemList = Rx([
    SafetyscreenItemModel(
        crashdetection: ImageConstant.imgCheckmark.obs,
        mother: "Crash detection".obs,
        crashdetection1: ImageConstant.imgCarCrashFill0.obs),
    SafetyscreenItemModel(
        mother: "Emergency dispatch".obs,
        crashdetection1: ImageConstant.imgMinorCrashFil.obs)
  ]);
}
