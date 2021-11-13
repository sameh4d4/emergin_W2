import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week2/class/popActor.dart';
import 'package:week2/main.dart';

List<popActor> PAs = [];

class PopularActor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PopularActorState();
  }
}

class _PopularActorState extends State<PopularActor> {

  Widget DaftarPopMovie(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.movie, size: 30),
                      title: Text(PopMovs[index].nama),
                      subtitle: Text(PopMovs[index].overview),
                    ),
                  ],
                )
            );

          });
    } else {
      return CircularProgressIndicator();
    }
  }
  Widget DaftarPopMovie2(data) {
    List<popActor> PMs2 = [];
    Map json = jsonDecode(data);
    for (var mov in json['data']) {
      popActor pm = popActor.fromJson(mov);
      PMs2.add(pm);
    }
    return ListView.builder(
        itemCount: PMs2.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person, size: 30),
                    title: Text(PMs2[index].nama),
                  ),
                ],
              ));
        });
  }


  String _temp = 'waiting API respond…';

  Future<String> fetchData() async {
    final response = await http
        .get(Uri.http(apiAddress, apiDir+'getperson.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        popActor pm = popActor.fromJson(mov);
        PAs.add(pm);
      }
      setState(() {
        _temp = PAs[2].nama;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Popular Movie') ),
        body: ListView(children: <Widget>[

          Container(
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DaftarPopMovie2(snapshot.data);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }))

          // Container(
          //     height: MediaQuery.of(context).size.height-200,
          //     child: DaftarPopMovie(PMs),
          // ),
          // Text(_temp),
        ])
    );
  }
}