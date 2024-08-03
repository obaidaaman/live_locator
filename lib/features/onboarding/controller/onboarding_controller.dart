import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';

class OnboardingController extends GetxController {
  Rx<String> lastCheckout = ''.obs;
  Rx<String> latitude = ''.obs;
  Rx<String> longitude = ''.obs;
  RxBool isCheckIn = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    // TODO: implement onInit
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
        var time = data['time'];
        latitude.value = data['latitude'] ?? '0';
        longitude.value = data['longitude'] ?? '0';

        lastCheckout.value = time;
      } else {
        lastCheckout.value = 'No checkout recorded';
      }
    } catch (e) {
      print('Error fetching last check-in time: $e');
      lastCheckout.value = 'Error fetching time';
    }
  }

  String _formatTime(Timestamp timestamp) {
    if (timestamp == null) return 'No time available';

    var time = timestamp.toDate();
    var formattedTime =
        DateFormat.jm().format(time); // 'jm' gives format like '5:08 PM'

    return formattedTime;
  }
}
