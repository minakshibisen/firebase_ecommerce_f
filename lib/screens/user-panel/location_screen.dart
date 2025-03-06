import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  LocationPickerScreenState createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _selectedLocation;
  String _address = "Tap to select location";
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location on load
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    _updateLocation(LatLng(position.latitude, position.longitude));

    // Move camera to current location
    _mapController.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  void _updateLocation(LatLng location) async {
    setState(() {
      _selectedLocation = location;
    });

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks.isNotEmpty ? placemarks.first : Placemark();

      setState(() {
        _address =
            "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}"
                .trim();
      });
    } catch (e) {
      setState(() {
        _address = "Address not found";
      });
    }
  }

  void _confirmLocation() {
    Navigator.pop(context, _address); // Return selected address to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? LatLng(22.7196, 75.8577),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _updateLocation,
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId("selected"),
                position: _selectedLocation!,
              )
            }
                : {},
          ),

          // Address Display
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: Text(
                _address,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Confirm Location Button
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Confirm Location",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // Floating button to fetch current location
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
