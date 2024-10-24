import '../../../core/app_export.dart';

/// This class is used in the [safetyscreen_item_widget] screen.

class SafetyscreenItemModel {
  SafetyscreenItemModel({
    this.crashdetection,
    this.mother,
    this.crashdetection1,
    this.id,
    this.doctor,
  }) {
    crashdetection = crashdetection ?? Rx(ImageConstant.imgCheckmark);
    mother = mother ?? Rx("Crash detection");
    crashdetection1 = crashdetection1 ?? Rx(ImageConstant.imgCarCrashFill0);
    id = id ?? Rx("");
  }

  Rx<String>? crashdetection;

  Rx<String>? mother;

  Rx<String>? crashdetection1;

  Rx<String>? id;

  Rx<String>? doctor;
}
