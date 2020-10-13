import 'package:awesome_loader/awesome_loader.dart';
import 'package:film_app/auth.dart';
import 'package:film_app/const.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/profile/homePage.dart';
import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{
  double _height = 0.0;
  double _width = 0.0;
  bool _loading =true;
  Map<String, dynamic> _profile;

  @override
  void initState() {
    super.initState();
    // _profile = null;
    // _loading = false;
    _loadingTime();
    _getSystemData();
  }

  _getSystemData(){
    Database database = new Database();
    database.getSystemData();
  }
  
  _loadingTime() async{
    await new Future.delayed(const Duration(seconds : 3));
    authservice.profile.listen((event) { 
      print("profile"+event.toString());
      setState(() {
        _profile = event;
        _loading = false;
      });
      if(_profile!= null){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(profile: _profile,)
          )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Container(
      height:_height,
      width:_width,
      color: ColorList.Black,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: _width,
              height: 178,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      'assets/image/film.png'
                    ),
                  ),
                  Text(
                    "Movies & Tv Shows",
                    style: TextStyle(
                      fontSize: 22,
                      color: ColorList.Red
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: 
              !_loading && _profile == null ?Container(
                height: 150,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        print("googleSignIn");
                        authservice.googleSignIn();
                      },
                      child: Container(
                        width: _width-60,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorList.Red,
                          borderRadius: BorderRadius.circular(3.0)
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),
                    
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()
                          )
                        );
                      },
                      child: Container(
                        width: _width-60,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(
                            color: ColorList.Red
                          )
                        ),
                        child: Center(
                          child: Text(
                            "Just go to home",
                            style: TextStyle(
                              fontSize: 20,
                              color: ColorList.Red
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ):Container(
                height: 150,
                width: _width,
                color: ColorList.Black.withOpacity(0.5),
                child:AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader3,
                  color: ColorList.Red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}