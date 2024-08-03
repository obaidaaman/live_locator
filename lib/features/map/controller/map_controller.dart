import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MapController extends GetxController {
  final Location _locationController = Location();
  Rx<LatLng> location = Rx<LatLng>(const LatLng(0.0, 0.0));
  StreamSubscription<LocationData>? _locationSubscription;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    }
    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.deniedForever) {
      permissionGranted = await _locationController.requestPermission();
    }
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
    }

    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        location.value =
            LatLng(locationData.latitude!, locationData.longitude!);
        print(
            'Live Location -> Lat: ${locationData.latitude} and ${locationData.longitude}');
      }
    });
  }

  Future<void> saveLocationandTime() async {
    DateTime dateTime = DateTime.now();
    String formattedTime = DateFormat.jm().format(dateTime);

    final checkOut = {
      'latitude': location.value.latitude.toString(),
      'longitude': location.value.longitude.toString(),
      'time': formattedTime
    };
    try {
      await firestore.collection('check outs').add(checkOut);
      print('Check-Out saved successfully');
    } catch (e) {
      print('Error saving check-out : $e');
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    location.close();
    _locationSubscription!.cancel();
    super.onClose();
  }
}
