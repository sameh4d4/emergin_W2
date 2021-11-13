import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:week2/class/genre.dart';
import 'package:week2/class/popMovie.dart';
import 'package:http/http.dart' as http;
import 'package:week2/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class EditPopMovie extends StatefulWidget {
    int movie_id;
    EditPopMovie({Key? key, required this.movie_id}) : super(key: key);
    @override
    EditPopMovieState createState() {
      return EditPopMovieState();
    }
}
class EditPopMovieState extends State<EditPopMovie> {
    //#region var
    final _formKey = GlobalKey<FormState>();
    TextEditingController _titleCont = new TextEditingController();
    TextEditingController _homepageCont = new TextEditingController();
    TextEditingController _overviewCont = new TextEditingController();
    TextEditingController _releaseDate = new TextEditingController();
    int _runtime = 100;
    Widget comboGenre = Text('tambah genre');
    File? _image=null;
    File? _imageProses=null;
    PopMovie pm=new PopMovie(id: 0, title: "title", homepage: "homepage", overview: "overview", release_date: "01-01-2000", runtime: 100, vote_average: "100", genres: [], persons: []);
    //#endregion

    //#region method
    void prosesFoto() {
      Future<Directory?> extDir = getExternalStorageDirectory();
      extDir.then((value) {
        String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
        final String filePath = value!.path + '/${_timestamp()}.jpg';
        _imageProses = File(filePath);
        img.Image temp = img.readJpg(_image!.readAsBytesSync());
        img.Image temp2 = img.copyResize(temp, width: 480, height: 640);
        img.drawString(temp2, img.arial_24, 4, 4, 'Kuliah Flutter', color: img.getColor(250, 250, 250));
        img.drawString(temp2,img.arial_24,4,40,active_user,color: img.getColor(250, 250, 250));
        img.drawString(temp2,img.arial_24,4,80,DateTime.now().toString(),color: img.getColor(250, 250, 250));
        setState(() {
          _imageProses!.writeAsBytesSync(img.writeJpg(temp2));
        });
      });
    }

    _imgGaleri() async {
      final picker = ImagePicker();
      final image = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 600,
          maxWidth: 600);
      // setState(() {
      _image = File(image!.path);
      prosesFoto();
      // });
    }

    _imgKamera() async {
      final picker = ImagePicker();
      final image =
      await picker.getImage(source: ImageSource.camera, imageQuality: 20);
      // setState(() {
      _image = File(image!.path);
      prosesFoto();
      // });
    }

    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                color: Colors.white,
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        tileColor: Colors.white,
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Galeri'),
                        onTap: () {
                          _imgGaleri();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Kamera'),
                      onTap: () {
                        _imgKamera();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      );
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
        setState(() {
          _titleCont.text = pm.title;
          _homepageCont.text = pm.homepage;
          _overviewCont.text = pm.overview;
          _releaseDate.text = pm.release_date;
          _runtime=pm.runtime;
        });
      });
    }

    void submit() async {
      print(pm.runtime.toString());
      final response = await http.post(
          Uri.parse(apiAddress+apiDir+"updateMovie.php"),
          body: {
      'title': pm.title,
      'overview': pm.overview,
      'homepage': pm.homepage,
      'release_date':pm.release_date,
      'runtime':pm.runtime.toString(),
      'movie_id': widget.movie_id.toString()
      });
      if (response.statusCode == 200) {
        print(response.body);
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
          List<int> imageBytes = _imageProses!.readAsBytesSync();
          print(imageBytes);
          String base64Image = base64Encode(imageBytes);
          final response2 = await http.post(
           Uri.parse(
             apiAddress+apiDir+'uploadPopMoviePoster.php',
           ),
           body: {
            'movie_id': widget.movie_id.toString(),
            'image': base64Image,
           });
          if (response2.statusCode == 200) {
          ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response2.body)));
          }
        }
      } else {
        throw Exception('Failed to read API');
      }
      
    }

    Future<List> daftarGenre() async {
      Map json;
      final response = await http.post(
        Uri.parse(apiAddress+apiDir+"getGenreByMovieId.php"),
        body: {'cari': widget.movie_id.toString()});
      if (response.statusCode == 200) {
        print(response.body);
        json = jsonDecode(response.body);
        return json['data'];
      } else {
        throw Exception('Failed to read API');
      }
    }

    void generateComboGenre() {
      //widget function for city list
      List<Genre> genres;
      var data = daftarGenre();
      data.then((value) {
        genres = List<Genre>.from(value.map((i) {
          return Genre.fromJSON(i);}));
        comboGenre = DropdownButton(
            dropdownColor: Colors.grey[100],
            hint: Text("tambah genre"),
            isDense: false,
            items: genres.map((gen) {
              return DropdownMenuItem(
                child: Column(children: <Widget>[
                  Text(gen.genre_name, overflow: TextOverflow.visible),
                ]),
                value: gen.genre_id,
              );
            }).toList(),
            onChanged: (value) {
              addGenre(value);
            });
      });
    }

    void addGenre(genre_id) async {
      final response = await http.post(
          Uri.parse(apiAddress+apiDir+"addGenreMovie.php"),
          body: {'genre_id': genre_id.toString(), 'movie_id': widget.movie_id.toString()
          });
      if (response.statusCode == 200) {
        print(response.body);
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses menambah genre')));
          setState(() {
            bacaData();
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    }

    void deleteGenre(genre_id)async{
      final response = await http.post(
          Uri.parse(apiAddress+apiDir+"deleteGenreMovie.php"),
          body: {'genre_id': genre_id.toString(), 'movie_id': widget.movie_id.toString()
          });
      if (response.statusCode == 200) {
        print(response.body);
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses menghapus genre')));
          setState(() {
            bacaData();
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    }
    //#endregion

    @override
    void initState() {
      super.initState();
      bacaData();
      setState(() {
        generateComboGenre();
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Edit Popular Movie"),
          ),
          body:SingleChildScrollView(
            child:Form(
              key: _formKey,
              child: Column(
                children: <Widget>
                [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      onChanged: (value) {
                        pm.title = value;
                      },
                      controller: _titleCont,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'judul harus diisi';
                        }
                        return null;
                      },
                    )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Website',
                        ),
                        onChanged: (value) {
                          pm.homepage = value;
                        },
                        controller: _homepageCont,
                        validator: (value) {
                          if (!Uri.parse(value!).isAbsolute) {
                            return 'alamat website salah';
                          }
                          return null;
                        },
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Overview',
                        ),
                        onChanged: (value) {
                          pm.overview = value;
                        },
                        controller: _overviewCont,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 6,
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Release Date',
                              ),
                              controller: _releaseDate,
                            )),
                          ElevatedButton(
                            onPressed: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2200))
                                  .then((value) {
                                setState(() {
                                  _releaseDate.text =
                                      value.toString().substring(0, 10);
                                });
                              });
                            },
                            child: Icon(
                              Icons.calendar_today_sharp,
                              color: Colors.white,
                              size: 24.0,
                            )
                          )
                        ],
                      )
                  ),
                  NumberPicker(
                    value: _runtime,
                    axis: Axis.horizontal,
                    minValue: 50,
                    maxValue: 300,
                    itemHeight: 30,
                    itemWidth: 60,
                    step: 1,
                    onChanged: (value) => setState(() {
                      _runtime = value;
                      pm.runtime=_runtime;
                    }),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10), child: Text("Genre:")),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pm.genres.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            // return new Text(pm.genres[index]['genre_name']);
                            return new Container(
                                height: 45.0,
                                decoration: BoxDecoration(
                                ),
                                child: new Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Container(
                                            child: Text(
                                              pm.genres[index]['genre_name'],
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))
                                            ),
                                          ),
                                          new GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                deleteGenre(pm.genres[index]['genre_id']);
                                              });
                                            },
                                            child: new Container(
                                                margin: const EdgeInsets.all(0.0),
                                                child: new Text("X")
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            );
                          }
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: comboGenre
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child:
                        _imageProses != null
                            ? Image.file(_imageProses!)
                            : Image.network("http://ubaya.fun/blank.jpg"),
                      )
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Harap Isian diperbaiki')));
                        } else {
                          submit();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            )
          )
      );
    }
}