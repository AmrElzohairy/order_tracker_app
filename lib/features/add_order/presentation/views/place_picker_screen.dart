import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

class PlacePickerScreen extends StatelessWidget {
  const PlacePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlacePicker(
        apiKey: 'AIzaSyBCk6CObXNzP695fUiG0HyT05_Ja2iIKlQ',
        onPlacePicked: (LocationResult result) {
          log("Place picked: ${result.formattedAddress}");
          debugPrint("Place picked: ${result.formattedAddress}");
          context.pop(result.latLng);
        },
        initialLocation: const LatLng(31.202235779613645, 29.915403785987124),
        searchInputConfig: const SearchInputConfig(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          autofocus: false,
          textDirection: TextDirection.ltr,
        ),
        searchInputDecorationConfig: const SearchInputDecorationConfig(
          hintText: "Search for a building, street or ...",
        ),
      ),
    );
  }
}
