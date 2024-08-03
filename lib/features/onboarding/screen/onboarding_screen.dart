import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_locator/features/last_location/last_location.dart';
import 'package:live_locator/features/map/view/map_location_page.dart';
import 'package:live_locator/features/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController _controller = Get.put(OnboardingController());

  @override
  void initState() {
    _controller.fetchLastCheckout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Live Tracker"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                'Welcome Back',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Your Stats:",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .25,
                child: Card(
                  color: Colors.grey.shade400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.3),
                                child: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Aman Obaid",
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text("Last Check Out at :"),
                            const SizedBox(
                              width: 3,
                            ),
                            Obx(() => Text(
                                  _controller.lastCheckout.value,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              double latitude =
                                  double.parse(_controller.latitude.value);
                              double longitude =
                                  double.parse(_controller.longitude.value);
                              Get.to(() => LastLocation(
                                    latitude: latitude,
                                    longitude: longitude,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.5)),
                            child: const Text(
                              'View on Map',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              if (_controller.isCheckIn.value) {
                return const CircularProgressIndicator(
                  color: Colors.blue,
                );
              } else {
                return ElevatedButton(
                  onPressed: () {
                    _controller.isCheckIn.value = !_controller.isCheckIn.value;
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LocationStream()))
                          .then((context) {
                        _controller.isCheckIn.value =
                            !_controller.isCheckIn.value;
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Check In Now",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
