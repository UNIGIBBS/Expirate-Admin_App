import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../providers/location_provider.dart';




class LocationService {
  UserLocation? _currentLocation;

  var location = Location();


  Future<UserLocation?> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  StreamController<UserLocation> _locationController = StreamController<
      UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
      else if(permissionStatus != PermissionStatus.granted){
        return CircularProgressIndicator();
      }
    });
  }
}

