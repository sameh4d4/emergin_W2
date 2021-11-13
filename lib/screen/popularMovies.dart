import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week2/class/popMovie.dart';
import 'package:week2/main.dart';
import 'package:week2/screen/DetailPop.dart';


class PopularMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PopularMovieState();
  }
}

class _PopularMovieState extends State<PopularMovie> {
    List<PopMovie> PMs = [];

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
                      title: GestureDetector(
                        child: Text(PMs[index].title),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPop(movie_id: PMs[index].id),
                            ),
                          );
                        }
                      ),
                      subtitle: Text(PopMovs[index].overview),
                    ),
                  ],
                )
              );
            }
        );
      } else {
        return CircularProgressIndicator();
      }
    }

    Widget DaftarPopMovie2(data) {
      if(data!="") {
        List<PopMovie> PMs2 = [];
        Map json = jsonDecode(data);
        for (var mov in json['data']) {
          PopMovie pm = PopMovie.fromJson(mov);
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
                        leading: Icon(Icons.movie, size: 30),
                        title: GestureDetector(
                            child: Text(PMs[index].title),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPop(movie_id: PMs[index].id),
                                ),
                              );
                            }
                        ),
                        subtitle: Text(PMs2[index].overview),
                      ),
                    ],
                  ));
            }
          );
      }
      else{
        return Text("waiting API respond…");
      }
    }

    String _txtcari='';
    String _temp = 'waiting API respond…';

    Future<String> fetchData() async {
      final response =
      await http.post(
        Uri.parse(apiAddress+apiDir+"getmoviesByTitle.php"),
        body: {'cari': _txtcari}
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to read API');
      }
    }

    bacaData() {
      PMs.clear();
      Future<String> data = fetchData();
      data.then((value) {
        Map json = jsonDecode(value);
        for (var mov in json['data']) {
          PopMovie pm = PopMovie.fromJson(mov);
          PMs.add(pm);
        }
        setState(() {
          _temp = PMs[2].title;
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
            title: const Text('Popular Movie')),
          body: ListView(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                labelText: 'Judul mengandung kata:',
              ),
              onFieldSubmitted: (value) {
                _txtcari = value;
                bacaData();
              },
            ),
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
                    }
                 )
            ),
          ])
      );
    }
}