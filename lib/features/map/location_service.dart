import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationMap extends StatefulWidget {
  const LiveLocationMap({super.key});

  @override
  State<LiveLocationMap> createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<LiveLocationMap> {
  late GoogleMapController _mapController;
  late StreamSubscription<Position> _positionStream;
  Set<Marker> _markers = {};
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _centerMap(position);
      _startLocationUpdates();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _centerMap(Position position) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17,
        ),
      ),
    );
  }

  void _debounceLocationUpdate(Position position) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 1000), () {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
          ),
        );
        _centerMap(position);
      });
    });
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(timeLimit: Duration(seconds: 5)))
        .listen((Position position) {
      _debounceLocationUpdate(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
      ),
    );
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
