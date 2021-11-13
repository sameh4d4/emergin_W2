import 'package:flutter/material.dart';
import 'studentDetails.dart';
class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StudentList'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is StudentList"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => StudentDetail(1))
                  );
                },
                child: Text("Student 1")
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => StudentDetail(2))
                  );
                },
                child: Text("Student 2")
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => StudentDetail(50))
                  );
                },
                child: Text("Student 3")
            ),
          ],
        ),
      ),
    );
  }
}