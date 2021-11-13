import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class QuestionObj {
  String narration;
  String option_a;
  String option_b;
  String option_c;
  String option_d;
  String answer;

  QuestionObj(this.narration, this.option_a,
      this.option_b, this.option_c, this.option_d, this.answer);
}

String formatTime(int hitung) {
    var secs = hitung;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
}

class _QuizState extends State<Quiz> {

  late Timer _timer;
  int _hitung=600;
  int _init=600;

  List<QuestionObj> _questions = [];
  int _question_no = 0;
  int _question_no2 = 0;
  int _point=0;

  finishQuiz(){
    _timer.cancel();
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Quiz'),
          content: Text('Your point = ' + _point.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        )
    );
  }

  void checkAnswer(String s) {
    setState(() {
      if (s == _questions[_question_no].answer) {
        _point += 100;
      }
      _question_no2=_question_no;
      _question_no2++;
      if (_question_no2 > _questions.length - 1) finishQuiz();
      else _question_no++;
      _hitung = _init;
    });
  }

  StartTimer(){
    _timer = new Timer.periodic(new Duration(milliseconds: 10), (timer) {
      setState(() {
        _hitung--;
        if(_hitung==0){
          _question_no2=_question_no;
          _question_no2++;
          if (_question_no2 > _questions.length - 1) finishQuiz();
          else _question_no++;
          _hitung = _init;
        }
        else {
          _isrun=true;
        }
      });
    });
  }

  bool _isrun=false;
  
  @override
  void initState() {
    super.initState();
    _isrun=true;
    StartTimer();

    _questions.add(QuestionObj("Not a member of Avenger", 'Ironman',
        'Spiderman', 'Thor', 'Hulk Hogan', 'Hulk Hogan'));
    _questions.add(QuestionObj("Not a member of Teletubbies", 'Dipsy', 'Patrick',
        'Laalaa', 'Poo', 'Patrick'));
    _questions.add(QuestionObj("Not a member of justice league", 'batman',
        'superman', 'flash', 'aquades', 'aquades'));

  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text('Add Recipe'),
        ),
      body:
      Center(
        child: Column(
          children: [
            Divider(height: 40,),
            LinearPercentIndicator(
              center: Text(formatTime(_hitung)),
              width: MediaQuery.of(context).size.width,
              lineHeight: 20.0,
              percent: 1 - (_hitung / _init),
              backgroundColor: Colors.grey,
              progressColor: Colors.red,
            ),

            // CircularPercentIndicator(
            //   radius: 120.0,
            //   lineWidth: 20.0,
            //   percent: 1 - (_hitung / _init),
            //   center: new Text(formatTime(_hitung)),
            //   progressColor: Colors.red,
            // ),

            // Text(formatTime(_hitung)),
            // _isrun==true?
            // ElevatedButton(
            //     onPressed: (){
            //       setState(() {
            //         _timer.cancel();
            //         _isrun=false;
            //       });
            //     },
            //     child: Text('Stop')
            // )
            // :ElevatedButton(
            //     onPressed: (){
            //       _isrun=true;StartTimer();
            //       },
            //     child: Text("Start")
            // ),

            Text(_questions[_question_no].narration),
            TextButton(
                    onPressed: () {
                 checkAnswer(_questions[_question_no].option_a);
                },
                    child: Text("A. " + _questions[_question_no].option_a)),
            TextButton(
              onPressed: () {
               checkAnswer(_questions[_question_no].option_b);
              },
              child: Text("B. " + _questions[_question_no].option_b)),
            TextButton(
              onPressed: () {
               checkAnswer(_questions[_question_no].option_c);
              },
              child: Text("C. " + _questions[_question_no].option_c)),
            TextButton(
              onPressed: () {
               checkAnswer(_questions[_question_no].option_d);
              },
              child: Text("D. " + _questions[_question_no].option_d)),

          ],
        ),
      ),
    );
  }
}


