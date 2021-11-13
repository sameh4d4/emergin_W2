import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class MyLogin extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login(),
      );
    }
}
class Login extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
      return _LoginState();
    }
}

class _LoginState extends State<Login> {
    late String _user_id;
    late String _user_password;
    late String error_login;

    // void doLogin() async {
    //    //later, we use web service here to check the user id and password
    //    final prefs = await SharedPreferences.getInstance();
    //    prefs.setString("user_id", _user_id); 
    //    main();
    // }

    void doLogin() async {
      final response = await http.post(
          Uri.parse(apiAddress+apiDir+"login.php"),
          body: {'user_id': _user_id, 'user_password': _user_password});
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("user_id", _user_id);
          prefs.setString("user_name", json['user_name']);
          active_user=json['user_name'];
          main();
        } else {
          setState(() {
            error_login = "User id atau password error";
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: Container(
              height: 300,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(width: 1),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 20)]
              ),
              child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter valid email id as abc@gmail.com',
                        ),
                        onChanged: (v) {
                          _user_id = v;
                        },
                      ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter secure password'
                        ),
                        onChanged: (v) {
                          _user_password = v;
                        },
                      ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () {
                            doLogin();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      )
                  ),
              ]),
          )
      );
    }
}
