import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  bool loading = false;
  List<Marker> allMarkers = [];
  List country_codes = [];
  List summary = [];
  CameraPosition _initialPostion =
      CameraPosition(target: LatLng(20.5937, 78.9629));
  Map globalData = {};
  GoogleMapController _controller;
  @override
  void initState() {
    super.initState();
    setAllMarkersPositions();
    //getSummaryOfAllCountries();
  }

  setAllMarkersPositions() async {
    setState(() {
      loading = true;
    });
    await getSummaryOfAllCountries();
    String url =
        "https://raw.githubusercontent.com/eesur/country-codes-lat-long/master/country-codes-lat-long-alpha3.json";
    var response = await http.get(Uri.encodeFull(url));
    if (response.statusCode == 200) {
      setState(() {
        country_codes = jsonDecode(response.body)["ref_country_codes"];
        var j = 0;
        for (var i = 0; i < summary.length; i++) {
          for (var j = 0; j < country_codes.length; j++) {
            if (summary[i]["Country"] == country_codes[j]["country"]) {
              double lat = country_codes[j]["latitude"].toDouble();
              double long = country_codes[j]["longitude"].toDouble();
              allMarkers.add(
                Marker(
                  markerId: MarkerId('${summary[i]["Country"]}'),
                  draggable: false,
                  infoWindow: InfoWindow(
                      title: 'Total Confirmed: ${summary[i]["TotalConfirmed"]}',
                      snippet: 'Total Deaths: ${summary[i]["TotalDeaths"]}'),
                  position: LatLng(lat, long),
                ),
              );
              break;
            }
          }
        }
      });
    }
    setState(() {
      loading = false;
    });
  }

  getSummaryOfAllCountries() async {
    try {
      String url = "https://api.covid19api.com/summary";
      http.Response response = await http.get(Uri.encodeFull(url));
      if (response.statusCode == 200) {
        var summaryData = jsonDecode(response.body);
        setState(() {
          globalData = summaryData["Global"];
          summary = summaryData["Countries"];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onMapCreated(GoogleMapController controller) {
      _controller = controller;
      print(controller.toString());
    }

    getSummaryOfAllCountries();

    return loading
        ? Container(
            child: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialPostion,
                  mapType: MapType.normal,
                  markers: Set.from(allMarkers),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Total Cases Globally: ${globalData["TotalConfirmed"]}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 22),
                  ),
                )
              ],
            ),
          );
  }
}
