import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_locator/features/map/controller/map_controller.dart';
import 'package:live_locator/features/onboarding/screen/onboarding_screen.dart';

class LocationStream extends StatefulWidget {
  final String lastCheckIn;
  LocationStream({super.key, required this.lastCheckIn});

  @override
  State<LocationStream> createState() => _LocationStreamState();
}

class _LocationStreamState extends State<LocationStream> {
  final MapController _mapController = Get.put(MapController());

  GoogleMapController? _googleMapController;
  bool _isCameraMovedByUser = false;
  @override
  void initState() {
    super.initState();
    print('Build');
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _mapController.location.listen((location) {
      if (_googleMapController != null) {
        _googleMapController!.animateCamera(CameraUpdate.newLatLng(location));
      }
    });
  }

  void _resetCameraPosition() {
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLng(_mapController.location.value),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() {
            if (_mapController.isCheckout.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 5),
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              return IconButton(
                  onPressed: () async {
                    _mapController.checkIntime.value = widget.lastCheckIn;
                    _mapController.isCheckout.value =
                        !_mapController.isCheckout.value;
                    Future.delayed(const Duration(seconds: 2), () {
                      _googleMapController!.dispose();
                      Get.delete<MapController>();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const OnboardingScreen())).then((context) {
                        _mapController.isCheckout.value =
                            !_mapController.isCheckout.value;
                      });
                    });
                  },
                  icon: const Icon(Icons.exit_to_app));
            }
          })
        ],
      ),
      body: Obx(() {
        if ((_mapController.location.value.latitude == 0.0 &&
            _mapController.location.value.longitude == 0.0)) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
              _googleMapController!.animateCamera(
                  CameraUpdate.newLatLng(_mapController.location.value));
            },
            initialCameraPosition:
                CameraPosition(target: _mapController.location.value, zoom: 17),
            markers: {
              Marker(
                  markerId: const MarkerId('Live Location'),
                  position: _mapController.location.value)
            },
            onCameraMoveStarted: () {
              _isCameraMovedByUser = true;
            },
            onCameraIdle: () {
              Future.delayed(const Duration(seconds: 5), () {
                _isCameraMovedByUser = false;
                _resetCameraPosition();
              });
            },
          );
        }
      }),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
