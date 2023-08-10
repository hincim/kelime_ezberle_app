import 'package:flutter/material.dart';
import 'package:kelimeezberle/pages/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {


  late AnimationController _animationController;
  late Animation<double> _translateAnimationValues;
  late AnimationController _alphaController;
  late Animation<double> _alphaAnimationValues;
  @override
  void initState() {
    super.initState();

   Future.delayed(const Duration(milliseconds: 3000),(){

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      const MainPage()
      ));
    });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _translateAnimationValues = Tween(begin: -800.0,end: 0.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))..addListener(() {
      setState(() {});
    });

    Future.delayed(const Duration(milliseconds: 1500),(){
      _alphaController.forward();

    });
    _alphaController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _alphaAnimationValues = Tween(begin: 0.0,end: 1.0).animate(_alphaController)..addListener(() {
      setState(() {});
    });
    _animationController.forward();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    _alphaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Transform.translate(
                          offset: Offset(-_translateAnimationValues.value, 0.0),
                          child: Image.asset("assets/images/logo.png")),
                       Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Transform.translate(
                          offset: Offset(_translateAnimationValues.value, 0.0),
                          child: Text("Kelime Ezberle",style: TextStyle(color: Colors.black,
                              fontFamily: "Carter",fontSize: 40),),
                        ),
                      ),
                      SizedBox(height: 60,)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Opacity(
                      opacity: _alphaAnimationValues.value,
                      child: Text("İstediğini Öğren",style: TextStyle(color: Colors.black,
                          fontFamily: "Carter",fontSize: 25),),
                    ),
                  ),
                  SizedBox(height: 60,),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Opacity(
                      opacity: _alphaAnimationValues.value,
                      child: Text("Pratik Yap",style: TextStyle(color: Colors.black,
                          fontFamily: "Carter",fontSize: 25),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}













