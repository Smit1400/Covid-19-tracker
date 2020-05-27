import 'package:flutter/material.dart';

class ListOfCountries extends StatelessWidget {
  final List summary;
  ListOfCountries({@required this.summary});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                  Text("Total Deaths", style: TextStyle(color: Colors.red)),
                  Text(
                    '${summary[index]["TotalDeaths"]}',
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              onTap: () =>
                  _showFurtherDetailsOfCountry(context, summary[index]),
            ),
            Divider(
              thickness: 2.0,
              color: Colors.grey,
            )
          ],
        );
      },
    );
  }

  Widget _showFurtherDetailsOfCountry(BuildContext context, Map data) {
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
                    Text("Total Deaths", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["TotalDeaths"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Total Recovered", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["TotalRecovered"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("New Confirmed", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("${data["NewConfirmed"]}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text("New deaths", style: TextStyle(fontSize: 20)),
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
}
