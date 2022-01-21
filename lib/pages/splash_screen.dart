import 'dart:async';

import 'package:app_challenge_01/pages/Homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  int value=0;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer=Timer.periodic(Duration(seconds: 1), (Timer timer){
      if(value==10){
        setState(() {
          _timer.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
        });
      }
      else{
        setState(() {
          value++;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${value}',style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),
            RaisedButton(onPressed: (){
              _timer.cancel();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
            },child: Text('SKIP',style: TextStyle(color: Colors.teal,fontSize: 18),),)
          ],
        ),
      ),
    );
  }
}
