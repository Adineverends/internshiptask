import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class appscreen extends StatefulWidget {
  const appscreen({Key? key}) : super(key: key);

  @override
  State<appscreen> createState() => _appscreenState();
}

class _appscreenState extends State<appscreen> with SingleTickerProviderStateMixin {


  Timer ? _timer;
  int _secondsRemaining = 30;
  int _timerCount = 0;
  String _timerText = '00:30';
  bool _isTimerRunning = false;
  bool _isPlaying = false;
  bool _showButton2 = false;

  List<String> _timerMessages1 = [
    'Tim to eat mindfully',
    'Nom nom:)',
    'Break Time',
    'Finish your meal'

  ];
  List<String> _timerMessages2 = [
    "It's simple:eat slowly for ten minutes,rest for                          \n                      five,then finish your meal",
    'You have 10 minutes to eat before the pause \n Focus on eating slowly',
    'Take a five minute break to check in on your \n level of fullness',
    'You can eat until you feel full'


  ];

  final player = AudioPlayer();
  AnimationController ? _animationController;
  Animation<double> ?  _animation;


  Future<void> _playSound() async {
    await player.setAsset('alertsound/beep.mp3');


      player.play();
    setState(() {
      _isPlaying = true;
    });

  }


   _pauseAudio() async {
    player.stop();
    setState(() {
      _isPlaying = false;
    });

    }




  void _startTimer() {
    _isTimerRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
        _timerText = _secondsToTimerText(_secondsRemaining);
        if (_secondsRemaining <= 5) {

          _playSound();
        }
        if (_secondsRemaining == 0) {
          _timerCount++;
          _timer!.cancel();
          _isTimerRunning = false;
          if (_timerCount < 3) {
            _secondsRemaining = 30;
            _timerText = '00:30';
            _showTimerMessage();
        // reset animation controller value to 0

          //  _playLottieAnimation();


            _startTimer();
          }

          _animationController!.stop();
          _animationController!.forward(from: 0);
        }
      });
    });
    //_animationController!.reset();
    _animationController!.forward(from: _animationController!.value);
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _isTimerRunning = false;
      _animationController!.stop();
    }
  }

  void _resetTimer() {
    _pauseTimer();
    _secondsRemaining = 30;
    _timerCount = 0;
    _timerText = '00:30';
    _animationController!.reset();
  }

  String _secondsToTimerText(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getCurrentTimerMessage1() {
    if (_timerCount < _timerMessages1.length) {
      return _timerMessages1[_timerCount];
    } else {
      return '';
    }
  }
  String _getCurrentTimerMessage2() {
    if (_timerCount < _timerMessages2.length) {
      return _timerMessages2[_timerCount];
    } else {
      return '';
    }
  }
  void _showTimerMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 45),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }











  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor:Color.fromRGBO(30, 6, 56, 2),
      appBar: new AppBar(
        title: Text('Mindful Meal timer'),
        backgroundColor:Color.fromRGBO(30, 6, 56, 2),
        leading: IconButton(onPressed: (){},
            icon:Icon(Icons.arrow_back,color: Colors.white,)

        ),
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 20,),
            Text(
              _getCurrentTimerMessage1(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 31),
              child: Text(
                _getCurrentTimerMessage2(),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),  SizedBox(height: 20,),
            Container(
              height: 330,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(170),
                border: Border.all(width: 31,color: Colors.grey.shade500),
                color: Colors.white
              ),
              child: Stack(
                children: [
                  Lottie.asset(
                    'alertsound/data.json',

                    width: 320,
                    frameRate: FrameRate.max,
                    repeat: true,
                    controller: _animationController,

                  ),
                  Positioned(
top: 100,left: 60,
                    child: Column(
                      children: [
                        Text(

                          _timerText,
                          style: TextStyle(fontSize: 32,color: Colors.black),
                        ),
                        Text(

                          'minutes remaning',
                          style: TextStyle(fontSize: 18,color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],

              ),
            ),
            SizedBox(height: 16,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(

              activeColor: Colors.green.shade600,
              value: _isPlaying,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _playSound();
                  } else {
                    _pauseAudio();
                  }
                });
              },
            ),
            Text('Sound On',style: TextStyle(color: Colors.white),),

          ]),

            SizedBox(height: 20,),
            Stack(
              children: [

                Container(
                  margin: EdgeInsets.only(top: 6),
                  height: 60,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.greenAccent.shade200,

                  ),

                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      if (_isTimerRunning) {
                        _pauseTimer();
                      } else {
                        _isTimerRunning = true;
                        _startTimer();
                      }
                      _showButton2 = true;
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.greenAccent.shade100,

                    ),
                    child:Text(_isTimerRunning == true?'PAUSE':'START') ,
                  ),
                ),
              ],

            ),
            SizedBox(height: 16,),
            if(_showButton2)
            InkWell(

              child: Container(
                height: 60,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white)
                ),
                child:Text("LET'S STOP I'M FULL NOW",style: TextStyle(color: Colors.white),) ,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
