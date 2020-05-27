import 'package:covid_19_tracker/app/summary_of_all_countrie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPreferences sharedPreferences;
  String name;
  bool check = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  void initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("name")) {
      setState(() {
        check = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return check
        ? SummaryOfAllCountries()
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Welcome To Covid Tracker',
                  style: TextStyle(color: Colors.orange)),
              centerTitle: true,
              titleSpacing: 2.0,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Covid Tracker',
                          style: TextStyle(fontSize: 30, color: Colors.red),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          hasFloatingPlaceholder: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // hintText: 'Enter your product title',
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Your Country Name',
                          hintText: 'Eg. India'),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: RaisedButton(
                        color: Colors.grey[100],
                        child: Text(
                          'Save Country Name',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        onPressed: () async {
                          print("name = $name");
                          sharedPreferences.setString("name", "$name");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SummaryOfAllCountries()),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
