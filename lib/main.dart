import 'package:flutter/material.dart';
import 'package:week2/screen/addRecipe.dart';
import 'package:week2/screen/login.dart';
import 'package:week2/screen/newPopMovie.dart';
import 'package:week2/screen/popularActor.dart';
import 'package:week2/screen/popularMovies.dart';
import 'package:week2/screen/quiz.dart';
import 'screen/about.dart';
import 'screen/Basket.dart';
import 'screen/home.dart';
import 'screen/search.dart';
import 'screen/history.dart';
import 'screen/studentList.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
final String apiAddress="http://ubaya.fun";
final String apiDir='/flutter/160418066/API/';

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_name = prefs.getString("user_name") ?? '';
  return user_name;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("user_name");
  main();
}

int _currentIndex = 0;

final List<Widget> _screens = [
  Home(),
  Search(),
  History()
];

final List<String> _title = ['Home', 'Screen', 'History'];

Widget MyDrawer(BuildContext context){
  return Drawer(
    elevation: 16.0,
    child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: Text(active_user),
            accountEmail: Text("nicky@email.com"),
            currentAccountPicture: CircleAvatar(
                backgroundImage:
                NetworkImage("https://i.pravatar.cc/150"))),
        ListTile(
          title: new Text("My Basket "),
          leading: new Icon(Icons.shopping_basket),
          onTap: () {
            Navigator.pushNamed(context, 'basket');
          },
        ),
        ListTile(
            title: Text("Add New Recipe"),
            leading: Icon(Icons.add),
            onTap: () {
              Navigator.pushNamed(context, 'addRecipe');
            }
        ),
        ListTile(
            title: Text("QUIZ"),
            leading: Icon(Icons.lock_clock),
            onTap: () {
              Navigator.pushNamed(context, 'quiz');
            }
        ),
        ListTile(
          title: new Text("Student"),
          leading: new Icon(Icons.person),
          onTap: (){
            Navigator.pushNamed(context, 'studentList');
          },
        ),
        ListTile(
          title: new Text("Popular Movies"),
          leading: new Icon(Icons.movie),
          onTap: (){
            Navigator.pushNamed(context, 'popMovie');
          },
        ),
        ListTile(
          title: new Text("Add Movie"),
          leading: new Icon(Icons.add_to_queue),
          onTap: (){
            Navigator.pushNamed(context, 'addMovie');
          },
        ),
        ListTile(
          title: new Text("Popular actor"),
          leading: new Icon(Icons.person),
          onTap: (){
            Navigator.pushNamed(context, 'popPerson');
          },
        ),
        ListTile(
            title: Text("About"),
            leading: Icon(Icons.help),
            onTap: () {
              Navigator.pushNamed(context, 'about');
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => About())
              // );
            }
        ),
        Divider(
          color: Colors.red,
          thickness: 1,
        ),
        ListTile(
            title: Text("Log Out"),
            leading: Icon(Icons.logout),
            onTap: () {
                doLogout();
            }
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Wellcome'),
      routes: {
        'about': (context) => About(),
        'basket': (context) => Basket(),
        'studentList': (context) => StudentList(),
        'addRecipe': (context) => AddRecipe(),
        'quiz':(context)=>Quiz(),
        'popMovie':(context)=>PopularMovie(),
        'popPerson':(context)=>PopularActor(),
        'addMovie':(context)=>NewPopMovie(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(context),
      appBar: AppBar(
        title: Text(_title[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      persistentFooterButtons: <Widget>[
           ElevatedButton(
              onPressed: () {},
              child: Icon( Icons.add),
           ),
           ElevatedButton(
              onPressed: () {},
              child: Icon( Icons.send),
           ),
        ],
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.teal,
            currentIndex: _currentIndex,
                    onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "Search",
                icon: Icon(Icons.search),
              ),
              BottomNavigationBarItem(
                label: "History",
                icon: Icon(Icons.history),
              ),
            ],

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
