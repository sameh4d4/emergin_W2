import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:week2/class/popMovie.dart';
import 'package:week2/screen/editPopMovie.dart';
import '../main.dart';

class DetailPop extends StatefulWidget {
    final int movie_id;
    DetailPop({required this.movie_id}) : super();
    @override
    State<StatefulWidget> createState() {
      return _DetailPopState();
    }
}



class _DetailPopState extends State<DetailPop> {
    PopMovie pm=new PopMovie(id: 0, title: "title", homepage: "homepage", overview: "overview", release_date: "01-01-2000", runtime: 100, vote_average: "100", genres: [], persons: []);
    @override
    void initState() {
      super.initState();
      bacaData();
    }

    Future<String> fetchData() async {
      final response = await http.post(
          Uri.parse(apiAddress+apiDir+"getmovieDetail.php"),
          //apiAddress dan apiDir ada di main.dart
          //isinya sebagai berikut
          // final String apiAddress="http://ubaya.fun";
          // final String apiDir='/flutter/160418066/API/';

          body: {'id': widget.movie_id.toString()});
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to read API');
      }
    }

    bacaData() {
      fetchData().then((value) {
        Map json = jsonDecode(value);
        pm = PopMovie.fromJson(json['data']);
        setState(() {});
      });
    }

    Future onGoBack(dynamic value) async {
      setState(() {
          bacaData();
      });
    }


    void deleteData() async {
      final response = await http.post(
          Uri.parse(apiAddress+apiDir+"deleteMovie.php"),
          //apiAddress dan apiDir ada di main.dart
          //isinya sebagai berikut
          // final String apiAddress="http://ubaya.fun";
          // final String apiDir='/flutter/160418066/API/';

          body: {'id': widget.movie_id.toString()});
      print(widget.movie_id.toString());
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses Menghapus Data')));
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        throw Exception('Failed to read API');
      }
    }

    Widget tampilData() {
      if (pm != null) {
        return Card(
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Text(pm.title, style: TextStyle(fontSize: 25)),
              Image.network(
                  apiAddress+apiDir+"images/"+widget.movie_id.toString()+".jpg"
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(pm.overview, style: TextStyle(fontSize: 15))
              ),
              Padding(padding: EdgeInsets.all(10), child: Text("Genre:")),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: pm.genres.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new Text(pm.genres[index]['genre_name']);
                      }
                  )
              ),
              Padding(padding: EdgeInsets.all(10), child: Text("Actors:")),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: pm.genres.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new Text(pm.persons[index]["nama_asli"]+" as "+pm.persons[index]["cast"]);
                      }
                  )
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: Text('Edit'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditPopMovie(movie_id: widget.movie_id),
                        ),
                      ).then(onGoBack);;
                    },
                  )
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Data Change Notice'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text('Are you sure want to delete this movie data?'),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                deleteData();
                              },
                              child: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, 'Cancel'),
                              child: Text("Cancel"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red),
                            )
                          ],
                        )
                    );
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                ),
              ),
            ]));
      } else {
        return CircularProgressIndicator();
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Detail of Popular Movie'),
          ),
          body: ListView(children: <Widget>[
            tampilData(),
          ]));
    }
}
