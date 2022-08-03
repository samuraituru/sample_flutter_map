import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MapApp());
}

class MapApp extends StatefulWidget {
  @override
  _MapAppState createState() => new _MapAppState();
}

class _MapAppState extends State<MapApp> {
  String _title = 'flutter_map_test';
  double lat = 35.681;
  double lng = 139.767;
  LatLng? tapLatLng;
  var currentPosition;
  List<Marker> markers = [
    Marker(
      point: LatLng(35.697, 139.775),
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: Icon(
            Icons.location_on,
            size: 40,
            color: Colors.red,
          ),
          onPressed: () {},
        ),
      ),
    )
  ];

  List<CircleMarker> circleMarkers = [
    // サークルマーカー1設定
    CircleMarker(
      color: Colors.yellow.withOpacity(0.7),
      radius: 20,
      borderColor: Colors.white.withOpacity(0.7),
      borderStrokeWidth: 6,
      point: LatLng(35.687, 139.775),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'map_app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        // flutter_map設定
        body: FlutterMap(
          // マップ表示設定
          options: MapOptions(
              center: LatLng(lat, lng),
              zoom: 14.0,
              interactiveFlags: InteractiveFlag.all,
              enableScrollWheel: true,
              scrollWheelVelocity: 0.00001,
              onTap: (tapPosition, latLng) {
                tapLatLng = latLng;
                print(tapLatLng);
                cleatePin(tapLatLng!);
              }),
          layers: [
            //背景地図読み込み (OSM)
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.jp/{z}/{x}/{y}.png",
            ),
            // サークルマーカー設定
            CircleLayerOptions(
              circles: circleMarkers,
            ),
            // ピンマーカー設定
            MarkerLayerOptions(
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    final latitude = position.latitude;
    final longitude = position.longitude;
    initCircleMarker(latitude, longitude);
    setState(() {
      print('currentPositionは${currentPosition}');
    });
  }

  void cleatePin(LatLng tapLatLng) {
    Marker marker = Marker(
      point: tapLatLng,
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: Icon(
            Icons.location_on,
            size: 40,
            color: Colors.red,
          ),
          onPressed: () {
            onTapPinCallBack(tapLatLng);
          },
        ),
      ),
    );
    markers.add(marker);
    setState(() {});
  }

  Future<void> onTapPinCallBack(LatLng latLng) async {
    final tapMarker = pinReturn(latLng, pinReturn);
    markers.add(tapMarker);
    markers.removeAt(1);
    print('Pinをタップしたよ');
    setState(() {});
  }

  Marker pinReturn(LatLng tapLatLng, void tapPin) {
    return Marker(
      point: tapLatLng,
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: Icon(
            Icons.location_on,
            size: 20,
            color: Colors.red,
          ),
          onPressed: () {
            pinReturn(tapLatLng, tapPin);
          },
        ),
      ),
    );
  }

  void initCircleMarker(double latitude, double longitude) {
    CircleMarker circleMarler = CircleMarker(
      color: Colors.indigo.withOpacity(0.9),
      radius: 10,
      borderColor: Colors.white.withOpacity(0.9),
      borderStrokeWidth: 3,
      point: LatLng(latitude, longitude),
    );
    circleMarkers.add(circleMarler);
  }

  void pinSizeChange() {}
}
