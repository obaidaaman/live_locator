import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LastLocation extends StatelessWidget {
  final double latitude;
  final double longitude;
  const LastLocation(
      {super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Last Location',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.blue.withOpacity(0.5),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.arrow_back_ios),
        // ),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 18),
        markers: {
          Marker(
              markerId: MarkerId("Last Location"),
              position: LatLng(latitude, longitude))
        },
      ),
    );
  }
}
