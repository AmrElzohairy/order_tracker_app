import 'dart:async';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracker_app/core/styling/app_assets.dart';
import 'package:order_tracker_app/core/styling/app_colors.dart';
import 'package:order_tracker_app/core/styling/app_styles.dart';
import 'package:order_tracker_app/core/utils/location_services.dart';
import 'package:order_tracker_app/core/widgets/spacing_widgets.dart'
    show HeightSpace;
import 'package:order_tracker_app/features/order/data/model/order_model.dart';

class OrderTrackScreen extends StatefulWidget {
  const OrderTrackScreen({super.key, required this.orderModel});
  final OrderModel orderModel;

  @override
  State<OrderTrackScreen> createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends State<OrderTrackScreen> {
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = 'AIzaSyBCk6CObXNzP695fUiG0HyT05_Ja2iIKlQ';
  LatLng? currentUserLocation;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Set<Marker> markers = {};
  loadMarkers(OrderModel order) async {
    final Uint8List orderMarkerIcon = await LocationServices.getBytesFromAsset(
      AppAssets.order,
      50,
    );
    final Uint8List truckMarkerIcon = await LocationServices.getBytesFromAsset(
      AppAssets.truck,
      50,
    );
    final Marker truckMarker = Marker(
      icon: BitmapDescriptor.bytes(truckMarkerIcon),
      markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid.toString()),
      position: LatLng(
        currentUserLocation!.latitude,
        currentUserLocation!.longitude,
      ),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "order id:#${order.orderId}",
                    style: AppStyles.black18BoldStyle,
                  ),
                  Text(
                    "order name: ${order.orderName}",
                    style: AppStyles.black18BoldStyle,
                  ),
                  Text(
                    "order arrival time: ${order.orderDate}",
                    style: AppStyles.black15BoldStyle,
                  ),
                  Text(
                    "order status: ${order.orderStatus}",
                    style: AppStyles.black15BoldStyle.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  HeightSpace(10),
                ],
              ),
            ),
          ),
          LatLng(currentUserLocation!.latitude, currentUserLocation!.longitude),
        );
      },
    );
    final Marker orderMarker = Marker(
      icon: BitmapDescriptor.bytes(orderMarkerIcon),
      markerId: MarkerId(order.orderId),
      position: LatLng(order.orderLat, order.orderLong),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "order id:#${order.orderId}",
                    style: AppStyles.black18BoldStyle,
                  ),
                  Text(
                    "order name: ${order.orderName}",
                    style: AppStyles.black18BoldStyle,
                  ),
                  Text(
                    "order arrival time: ${order.orderDate}",
                    style: AppStyles.black15BoldStyle,
                  ),
                  Text(
                    "order status: ${order.orderStatus}",
                    style: AppStyles.black15BoldStyle.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  HeightSpace(10),
                ],
              ),
            ),
          ),
          LatLng(order.orderLat, order.orderLong),
        );
      },
    );
    markers.addAll([truckMarker, orderMarker]);

    setState(() {});
  }

  Future<void> _animateToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 16),
      ),
    );
  }

  getCurrentPositionAndAnimateToIT() async {
    try {
      Position position = await LocationServices.determinePosition();
      currentUserLocation = LatLng(position.latitude, position.longitude);
      _animateToPosition(LatLng(position.latitude, position.longitude));
    } catch (e) {
      log(e.toString());
    }
  }

  _getPolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleAPiKey,
        request: PolylineRequest(
          origin: PointLatLng(
            currentUserLocation!.latitude,
            currentUserLocation!.longitude,
          ),
          destination: PointLatLng(
            widget.orderModel.orderLat,
            widget.orderModel.orderLong,
          ),
          mode: TravelMode.driving,
          // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLine();
    } on Exception catch (e) {
      log("Error getting polyline => $e");
    }
  }

  _addPolyLine() {
    try {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: AppColors.primaryColor,
        points: polylineCoordinates,
        width: 5,
      );
      polylines[id] = polyline;
      setState(() {});
    } on Exception catch (e) {
      log("Error adding polyline => $e");
    }
  }

  @override
  void initState() {
    initMarkersAndLocations();
    super.initState();
  }

  initMarkersAndLocations() async {
    await getCurrentPositionAndAnimateToIT();
    _getPolyline();
    loadMarkers(widget.orderModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.orderModel.orderLat,
                widget.orderModel.orderLong,
              ),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (argument) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            markers: markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
