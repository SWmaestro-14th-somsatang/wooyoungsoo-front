import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wooyoungsoo/models/facility_model.dart';
import 'package:wooyoungsoo/services/facility_service/facility_service.dart';
import 'package:wooyoungsoo/utils/constants.dart';
import 'package:wooyoungsoo/widgets/common/navigation_bar_widget.dart';

/// 주변 편의시설 화면
class NearbyFacilityScreen extends StatefulWidget {
  const NearbyFacilityScreen({Key? key}) : super(key: key);

  @override
  State<NearbyFacilityScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<NearbyFacilityScreen> {
  final FacilityService facilityService = FacilityService();
  List<FacilityModel> nearbyFacilities = [];
  late AppleMapController mapController;
  Annotation? selectedAnnotation;
  BitmapDescriptor? defaultIcon;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMapCreated(AppleMapController controller) {
    mapController = controller;
  }

  void loadDefaultIcon() async {
    defaultIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(12, 12),
      ),
      "assets/images/hotel_icon.png",
    );
  }

  @override
  void initState() {
    super.initState();
    loadDefaultIcon();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    const int currentIndex = 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        shadowColor: transparentColor,
        leadingWidth: 115,
        leading: Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: screenWidth * 0.033,
          ),
          child: const Text(
            "내 주변",
            style: TextStyle(
              fontSize: 18,
              fontWeight: fontWeightBold,
              color: blackColor,
            ),
          ),
        ),
      ),
      backgroundColor: whiteColor,
      bottomNavigationBar:
          const PetdoriNavigationBar(currentIndex: currentIndex),
      body: Column(
        children: [
          Expanded(
            child: AppleMap(
              annotations: Set<Annotation>.of(
                nearbyFacilities.map(
                  (facility) => Annotation(
                    annotationId: AnnotationId(facility.name),
                    position: LatLng(facility.latitude, facility.longitude),
                    icon: defaultIcon!,
                  ),
                ),
              ),
              onMapCreated: _onMapCreated,
              trackingMode: TrackingMode.follow,
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.328628, 127.100229),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await mapController.getZoomLevel();
              LatLngBounds res = await mapController.getVisibleRegion();
              LatLng northEast = res.northeast;
              LatLng southWest = res.southwest;
              double centerLat = (northEast.latitude + southWest.latitude) / 2;
              double centerLng =
                  (northEast.longitude + southWest.longitude) / 2;

              int distance = Geolocator.distanceBetween(
                      centerLat, centerLng, centerLat, southWest.longitude)
                  .toInt();
              print("${northEast.latitude}, ${northEast.longitude}");
              print("centerLat: $centerLat, centerLng: $centerLng");
              print("distance: $distance");

              nearbyFacilities = await facilityService.getNearbyFacilities(
                latitude: centerLat,
                longitude: centerLng,
                radius: distance,
              );

              setState(() {});
            },
            child: const Text("버튼"),
          ),
        ],
      ),
    );
  }
}
