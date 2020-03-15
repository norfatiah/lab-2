import 'package:flutter/material.dart';
import 'package:fa_cosmetic/loginscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: new ThemeData(
primarySwatch: Colors.red),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
       backgroundColor: Color(0xFF444152),
       body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Image.asset(
                  'assets/images/logo2.png',
                   width: 230,
                   height: 230,
             ),
             SizedBox(
                   height: 20,
            ),
          new ProgressIndicator(),
          
    ],
   ),
  ),
 ),
);

  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;



  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }


@override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
      //width: 300,
      child: CircularProgressIndicator(
        value: animation.value,
        //backgroundColor: Colors.brown,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red,
      
    )
      )
    ));
  }


}