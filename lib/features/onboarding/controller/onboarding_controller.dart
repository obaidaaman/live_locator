import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_locator/features/onboarding/model/data_model.dart';

class OnboardingController extends GetxController {
  Rx<String> lastCheckout = ''.obs;
  Rx<String> latitude = ''.obs;
  Rx<String> longitude = ''.obs;
  RxBool isCheckIn = false.obs;
  RxString lastCheckIn = ''.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchLastCheckout();
  }

  Future<void> fetchLastCheckout() async {
    try {
      var snapshot = await firestore
          .collection('check outs')
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();

        DataModel model = DataModel.fromMap(data);

        // var time = data['time'];
        // var checkIntime = data['checkInTime'];
        // latitude.value = data['latitude'] ?? '0';
        // longitude.value = data['longitude'] ?? '0';

        lastCheckout.value = model.checkOutTime;

        lastCheckIn.value = model.checkInTime;

        latitude.value = model.latitude;

        longitude.value = model.longitude;
      } else {
        lastCheckout.value = 'No checkout recorded';
        lastCheckIn.value = 'No checkin recorded';
      }
    } catch (e) {
      print('Error fetching last check-in time: $e');
      lastCheckout.value = 'Error fetching time';
    }
  }

  void formatTime() {
    DateTime dateTime = DateTime.now();
    String formattedTime = DateFormat.jm().format(dateTime);

    lastCheckIn.value = formattedTime;
  }
}
