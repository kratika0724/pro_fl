import 'package:family_location_app/presentation/safety_screen/controller/safety_controller.dart';
import 'package:get/get.dart';

/// A binding class for the SafetyScreen.
///
/// This class ensures that the SafetyController is created when the
/// SafetyScreen is first loaded.
class SafetyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SafetyController());
  }
}
