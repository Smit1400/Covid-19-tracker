import 'dart:convert';

import 'package:covid_19_tracker/app/show_map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SummaryOfAllCountries extends StatefulWidget {
  @override
  _SummaryOfAllCountriesState createState() => _SummaryOfAllCountriesState();
}

class _SummaryOfAllCountriesState extends State<SummaryOfAllCountries> {
  String name;
  Map finalData = {};
  int _currentIndex = 0;
  List summary = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getSummaryOfAllCountries();
  }

  getSummaryOfAllCountries() async {
    try {
      String url = "https://api.covid19api.com/summary";
      http.Response response = await http.get(Uri.encodeFull(url));
      if (response.statusCode == 200) {
        var summaryData = jsonDecode(response.body);
        setState(() {
          summary = summaryData["Countries"];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    getSummaryOfAllCountries();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Summary', style: TextStyle(color: Colors.orange)),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              await getSummaryOfAllCountries();
              setState(() {
                loading = false;
              });
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
            ),
            label: Text(
              'Refresh',
              style: TextStyle(color: Colors.orange),
            ),
          )
        ],
      ),
      body: _currentIndex == 0 ? _buildContent() : _showYourCountryData(),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.indigo,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            title: Text('Country'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ShowMap()));
        },
        label: Text('Map'),
        icon: Icon(
          Icons.map,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildContent() {
    getSummaryOfAllCountries();
    return loading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : summary.isEmpty
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: summary.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://www.countryflags.io/${summary[index]["CountryCode"]}/shiny/64.png"),
                        ),
                        title: Text('${summary[index]["Country"]}',
                            style: TextStyle(color: Colors.teal)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Total Deaths",
                                style: TextStyle(color: Colors.red)),
                            Text(
                              '${summary[index]["TotalDeaths"]}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        onTap: () =>
                            _showFurtherDetailsOfCountry(summary[index]),
                      ),
                      Divider(
                        color: Colors.grey,
                      )
                    ],
                  );
                },
              );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _showFurtherDetailsOfCountry(Map data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Confirmed cases: ",
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["TotalConfirmed"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Total Deaths: ", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["TotalDeaths"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Total Recovered: ", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["TotalRecovered"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("New Confirmed: ", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["NewConfirmed"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("New deaths: ", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["NewDeaths"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.teal,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString("name");
    });
  }

  void getData() async {
    await getSummaryOfAllCountries();
    // print(summary[89]);
    for (var x in summary) {
      if (x["Country"] == "$name") {
        setState(() {
          finalData = x;
        });
        break;
      }
    }
  }

  Widget _showYourCountryData() {
    getName();
    getData();
    return finalData.isEmpty
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Country ",
                      style: TextStyle(fontSize: 25, color: Colors.orange)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${finalData["Country"]}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.teal)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Total Confirmed cases: ",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${finalData["TotalConfirmed"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Total Deaths: ",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${finalData["TotalDeaths"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Total Recovered: ",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${finalData["TotalRecovered"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("New Confirmed: ",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${finalData["NewConfirmed"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("New deaths: ",
                      style: TextStyle(fontSize: 20, color: Colors.orange)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("${finalData["NewDeaths"]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal)),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }
}
