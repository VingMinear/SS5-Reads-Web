import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/widgets/primary_button.dart';
import 'dart:ui' as ui;

import '../model/address.dart';
import 'input_field.dart';

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({
    super.key,
  });

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  var con = Get.put(MapController());
  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  late CameraPosition cameraPosition;
  BitmapDescriptor marker = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    con.txtLocationDetail.value.clear();
    cameraPosition = CameraPosition(
      target: con.latLng,
      zoom: 15,
    );
    super.initState();
  }

  var padding = const EdgeInsets.all(20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
          init: con,
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    padding: padding,
                    mapToolbarEnabled: false,
                    markers: {con.marker.value},
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (controller) {
                      con.googleMapController = controller;
                    },
                    onTap: (argument) async {
                      con.setMarker(argument);
                      await con
                          .getLocation(
                            latLng: argument,
                          )
                          .then((value) {});
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15).copyWith(left: 20, right: 20),
                  child: Column(
                    children: [
                      InputField(
                        hintText: 'Address',
                        readOnly: true,
                        controller: con.txtLocationDetail.value,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        child: CustomPrimaryButton(
                          textValue: "Confirm Address",
                          textColor: Colors.white,
                          onPressed: () async {
                            con
                                .getLocation(
                              latLng: con.latLng,
                            )
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class MapController extends GetxController {
  @override
  void onInit() {
    marker = Marker(
      icon: appMarker,
      markerId: const MarkerId("marker"),
      position: latLng,
    ).obs;
    super.onInit();
  }

  Address address = Address();
  late Rx<Marker> marker;
  LatLng latLng = const LatLng(11.569563004287103, 104.90264560955421);
  GoogleMapController? googleMapController;
  GoogleMapController? smallMapController;

  var txtLocationDetail = TextEditingController().obs;

  var listLocation = <Location>[].obs;
  BitmapDescriptor appMarker = BitmapDescriptor.defaultMarker;
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  customMarkerIcon() async {
    Uint8List icon = await getBytesFromAsset(
      'assets/icons/pin.png',
      100,
    );
    appMarker = BitmapDescriptor.fromBytes(icon);
  }

  void clear() {
    txtLocationDetail.value.text = "";
  }

  void clearMarker() {
    update();
  }

  Future<String> getLocation({
    required LatLng latLng,
  }) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    var place = placemarks[0];
    var locationDetail =
        "${place.street},${place.administrativeArea},${place.name},${place.country}";
    address = Address(
      province: place.administrativeArea,
      district: place.subAdministrativeArea,
      commune: place.street,
    );
    txtLocationDetail.value.text = locationDetail;
    log(locationDetail);
    GlobalClass().latlng = latLng;
    update();
    return locationDetail;
  }

  void currentLocaton() async {
    final position = await determinePosition();
    GlobalClass().latlng = LatLng(position.latitude, position.longitude);
    latLng = GlobalClass().latlng!;
    marker(
      Marker(
        icon: appMarker,
        markerId: const MarkerId("marker"),
        position: latLng,
      ),
    );
    await getLocation(latLng: latLng);
    update();
  }

  void setMarker(LatLng postion) {
    latLng = GlobalClass().latlng!;
    marker(
      Marker(
        icon: appMarker,
        position: postion,
        markerId: const MarkerId("marker"),
      ),
    );
    latLng = postion;
    moveCamera(postion);
    update();
  }

  void moveSmallCamera(LatLng postion) {
    smallMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: postion,
          zoom: 15.3,
        ),
      ),
    );
  }

  void moveCamera(LatLng postion) {
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: postion,
          zoom: 15.3,
        ),
      ),
    );
    debugPrint("move");
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      GlobalClass().isMapOff.value = false;
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      GlobalClass().isMapOff.value = false;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        GlobalClass().isMapOff.value = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      GlobalClass().isMapOff.value = false;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    GlobalClass().isMapOff.value = true;
    return await Geolocator.getCurrentPosition();
  }
}

class Location {
  Icon? icon;
  LatLng? latLng;
  String? locationName;
  String? locationDetails;
  String? locationDescription;
  Location({
    this.latLng,
    this.icon,
    this.locationName,
    this.locationDetails,
    this.locationDescription,
  });
}
