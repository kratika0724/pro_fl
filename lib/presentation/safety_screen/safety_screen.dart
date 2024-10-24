import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:family_location_app/widgets/app_bar/custom_app_bar.dart';
import 'package:family_location_app/widgets/app_bar/appbar_subtitle.dart';
import 'package:family_location_app/widgets/app_bar/appbar_title_image.dart';
import 'package:family_location_app/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:family_location_app/widgets/custom_image_view.dart';
import 'package:family_location_app/core/app_export.dart';
import 'package:family_location_app/presentation/create_a_circle_bottomsheet/create_a_circle_bottomsheet.dart';
import 'package:family_location_app/presentation/create_a_circle_bottomsheet/controller/create_a_circle_controller.dart';
import 'package:family_location_app/presentation/home_screen_bottomsheet/home_screen_bottomsheet.dart';
import 'package:family_location_app/presentation/home_screen_bottomsheet/controller/home_screen_controller.dart';
import 'package:intl/intl.dart';
import 'controller/safety_controller.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({Key? key}) : super(key: key);

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  SafetyController controller = Get.put(SafetyController());
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _geotaggedPhotos;
  String _location = "Location: Unknown";
  Position? _cachedPosition; // Cache position for faster retrieval

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.h),
        child: ListView(
          children: [
            _buildGeotaggedPhotoSection(),
            SizedBox(height: 24.v),
            _buildTimeStampSection(),
            SizedBox(height: 24.v),
            _buildMeetingHistorySection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: Padding(
        padding: EdgeInsets.only(left: 20.h),
        child: Row(
          children: [
            AppbarSubtitle(text: "lbl_jane_cooper".tr),
            AppbarTitleImage(
              imagePath: ImageConstant.imgSjdfhbjuew,
              margin: EdgeInsets.only(left: 16.h),
              onTap: () {
                onTapSjdfhbjuew();
              },
            ),
          ],
        ),
      ),
      actions: [
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgChatBubbleFil,
          margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.v),
          onTap: () {
            onTapChatBubbleFIL();
          },
        ),
      ],
      styleType: Style.bgFill,
    );
  }

  Widget _buildGeotaggedPhotoSection() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Geotagged Photos", style: theme.textTheme.titleLarge),
          SizedBox(height: 12.v),
          _buildPhotoUploadAndLocation(),
          if (_geotaggedPhotos != null && _geotaggedPhotos!.isNotEmpty)
            SizedBox(height: 12.v),
          if (_geotaggedPhotos != null)
            Wrap(
              spacing: 8.0,
              children: _geotaggedPhotos!.map((photo) {
                return Image.file(File(photo.path),
                    height: 80, width: 80, fit: BoxFit.cover);
              }).toList(),
            ),
        ],
      ),
    );
  }

  // Widget _buildGeotaggedPhotoSection() {
  //   return Container(
  //     padding: EdgeInsets.all(16.h),
  //     decoration: AppDecoration.outlineBlack.copyWith(
  //       borderRadius: BorderRadiusStyle.roundedBorder12,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Add Geotagged Photos", style: theme.textTheme.titleLarge),
  //         SizedBox(height: 12.v),
  //         _buildPhotoUploadAndLocation(),
  //         if (_geotaggedPhotos != null && _geotaggedPhotos!.isNotEmpty)
  //           SizedBox(height: 12.v),
  //         if (_geotaggedPhotos != null)
  //           Wrap(
  //             spacing: 8.0,
  //             children: _geotaggedPhotos!.map((photo) {
  //               return Image.network(
  //                 photo.path,
  //                 // Using network image as the file is now in the cloud
  //                 height: 80,
  //                 width: 80,
  //                 fit: BoxFit.cover,
  //               );
  //             }).toList(),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPhotoUploadAndLocation() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 300) {
          return Row(
            children: [
              TextButton(
                onPressed: _uploadPhoto,
                child: Text("Upload Photo"),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: _buildLocationDisplay(),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: _uploadPhoto,
                child: Text("Upload Photo"),
              ),
              SizedBox(height: 8.v),
              _buildLocationDisplay(),
            ],
          );
        }
      },
    );
  }

  Widget _buildLocationDisplay() {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.homeSelected,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
        SizedBox(width: 8.h),
        Expanded(
          child: Text(
            _location,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Future<void> _uploadPhoto() async {
    // Use cached position if available, otherwise get new position
    Position position = _cachedPosition ?? await _determinePosition();
    String address = await _getAddressFromLatLng(position);

    setState(() {
      _location = "Location: $address";
      _cachedPosition = position; // Cache position for future use
    });

    final List<XFile>? selectedPhotos = await _picker.pickMultiImage();
    if (selectedPhotos != null) {
      setState(() {
        _geotaggedPhotos = selectedPhotos;
      });
    }
  }

  Widget _buildTimeStampSection() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
    final formattedTime = DateFormat.jm().format(now);

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Meeting Time", style: theme.textTheme.bodyLarge),
          Text('$formattedDate at $formattedTime',
              style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildMeetingHistorySection() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Previous Doctor Meetings", style: theme.textTheme.titleLarge),
          SizedBox(height: 12.v),
          _buildFilterOptions(),
          SizedBox(height: 16.v),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Filter by Date"),
            items: [
              DropdownMenuItem(value: "Today", child: Text("Today")),
              DropdownMenuItem(value: "This Week", child: Text("This Week")),
              DropdownMenuItem(value: "This Month", child: Text("This Month")),
            ],
            onChanged: (value) {
              // Logic for filtering by date
            },
          ),
        ),
        SizedBox(width: 16.h),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Filter by Category"),
            items: [
              DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
              DropdownMenuItem(
                  value: "Cardiologist", child: Text("Cardiologist")),
              DropdownMenuItem(
                  value: "General Physician", child: Text("General Physician")),
            ],
            onChanged: (value) {
              // Logic for filtering by category
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            "Meeting with Dr. Smith",
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Text("Location: New York, USA | Time: 2024-10-10 12:00"),
          trailing: CustomImageView(
            imagePath: ImageConstant.homeSelected,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
          onTap: () {
            // View details of this meeting
          },
        );
      },
    );
  }

  Future<Position> _determinePosition() async {
    if (_cachedPosition != null) {
      return _cachedPosition!;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String street = place.street ?? "";
      String neighborhood = place.subLocality ?? "";
      String city =
          place.locality ?? place.administrativeArea ?? "Unknown City";
      String postalCode = place.postalCode ?? "";

      return '$street, $neighborhood, $city, $postalCode';
    }

    return "Unknown location";
  }

  void onTapSjdfhbjuew() {
    Get.bottomSheet(
      CreateACircleBottomsheet(
        Get.put(CreateACircleController()),
      ),
      isScrollControlled: true,
    );
  }

  void onTapChatBubbleFIL() {
    Get.toNamed(AppRoutes.chatOneScreen);
  }

  void onTapImgIcon() {
    Get.bottomSheet(
      HomeScreenBottomsheet(
        Get.put(HomeScreenController()),
      ),
      isScrollControlled: true,
    );
  }

  void onTapIcon() {
    Get.toNamed(AppRoutes.membershipScreen);
  }

  void onTapIcon1() {
    Get.toNamed(AppRoutes.guestProfileScreen);
  }
}
