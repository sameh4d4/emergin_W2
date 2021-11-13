import 'package:flutter/material.dart';
List<Widget> cats() {
  List<Widget> temp = [];
  int i = 0;
  while (i < 15) {
    Widget w = Image.network(
        "https://placekitten.com/120/120?image=" + i.toString());
    temp.add(w);
    i++;
  }
  return temp;
}
class About extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children:[
              Container(
                  color: Colors.yellow,
                  alignment: Alignment.center,
                  width:200.0,
                  height: 200.0,
                  child: AspectRatio(
                    aspectRatio: 4 / 1,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
              ),
              Container(
                color: Colors.cyan,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                height: 300,
                width: 300,
                child: Card(child: Text('Hello World!')),
              ),
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/400?img=60'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: Colors.indigo,
                    width: 10,
                  ),
                shape: BoxShape.circle
                ),
              ),
              Row(
                children: [
                  Image.network('https://i.pravatar.cc/100?img=1'),
                  Image.network('https://i.pravatar.cc/100?img=2'),
                  Image.network('https://i.pravatar.cc/100?img=3'),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            Divider(
              height: 20,
            ),
              SingleChildScrollView(
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network('https://i.pravatar.cc/100?img=4'),
                    Image.network('https://i.pravatar.cc/100?img=5'),
                    Image.network('https://i.pravatar.cc/100?img=6'),
                    Image.network('https://i.pravatar.cc/100?img=7'),
                    Image.network('https://i.pravatar.cc/100?img=8'),
                    Image.network('https://i.pravatar.cc/100?img=9'),
                  ],
                ),
                scrollDirection: Axis.horizontal,
              ),
              Divider(
                height: 40,
              ),
              Stack(
                children: [
                  Image.network("https://placekitten.com/420/320?image=12"),
                  Image.asset("assets/images/missing.png")
                ],
              ),
              Container(
                 height: 500,
                 child: GridView.count(crossAxisCount: 3, children: cats()),
              ),
            ],
          ),
        )
      );
    }
}