import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/utils.dart' as utils;

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

  String _cityEntered;

Future _goToNextScreen(BuildContext context) async {
  Map results = await Navigator.of(context).push(
    new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    })
  );

  if(results != null && results.containsKey("enter")) {
    _cityEntered = results["enter"];
//    debugPrint(_cityEntered);
  }
}

//  void showStuff() async {
//    Map data = await getWeather(utils.appid, _cityEntered);
//    debugPrint("Api data:~ $data");
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Climatic", textDirection: TextDirection.ltr,),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu),
              onPressed: (){
                _goToNextScreen(context);
              }),
        ],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/umbrella.png",
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,
            ),
          ),

          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text("${_cityEntered == null ? utils.defaultcity : _cityEntered}", textDirection: TextDirection.ltr,
            style: cityTextStyle(),),
          ),

          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),
          updateTempWidget(_cityEntered)

//          new Container(
//            margin: const EdgeInsets.fromLTRB(30.0, 390.0, 0.0, 0.0),
//            child: updateTempWidget(_cityEntered),
//          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appid, String cityname) async {
    String apiurl = "https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=$appid&units=metric";
    http.Response response = await http.get(apiurl);
    return json.decode(response.body);
  }

  //  custom widget container

  Widget updateTempWidget(String cityName) {

    return new FutureBuilder(
        future: getWeather(utils.appid, cityName == null ? utils.defaultcity : cityName),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
      if(snapshot.hasData) {
        Map content = snapshot.data;

        return new Container(
          margin: const EdgeInsets.fromLTRB(30.0, 390.0, 0.0, 0.0),
          alignment: Alignment.center,
          child: new ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              new ListTile(
                title: new Text("${content["main"]["temp"]} °F",
                  textDirection: TextDirection.ltr,
                style: tempStyle(),),
              ),

              new ListTile(
                title: new Text("Humidity: ${content['main']['humidity']} \n"
                                "Min: ${content['main']['temp_min']} °F \n"
                                "Max: ${content['main']['temp_max']} °F \n",
                style: extraData(),),
              )
            ],
          ),
        );
      } else {
        return new Container();
      }
    });
  }

}

TextStyle cityTextStyle() {
  return new TextStyle(
    fontSize: 30.9,
    color: Colors.white,
    fontStyle: FontStyle.normal,
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}

TextStyle extraData() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    fontSize: 17.3,
    letterSpacing: 1.5,
  );
}


class ChangeCity extends StatelessWidget {

  var _cityNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        title: new Text("Change city"),
        centerTitle: true,
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/white_snow.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Enter city name here"
                  ),
                  controller: _cityNameController,
                  keyboardType: TextInputType.text,
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "enter": _cityNameController.text.toString(),
                      });
                    },
                    color: Colors.redAccent,
                    textColor: Colors.white70,
                    child: new Text("Get weather")),
              )
            ],
          ),
        ],
      ),
    );
  }
}

