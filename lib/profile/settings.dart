import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../const.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _height = 0.0;
  double _width = 0.0;
  bool _notification = false;
  final storage = new FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    String notificationValue = await storage.read(key: KeyContainer.NOTIFICATION);
    print(notificationValue);
    setState(() {
      _notification = notificationValue == null ?true: notificationValue == "true"?true:false;
    });
  }

  _rateUs(){
    LaunchReview.launch(androidAppId: AppData.appIdAndroid,iOSAppId: AppData.appIdIos);
  }

  _shareWithOther(){
    Share.share('Android https://play.google.com/store/apps/details?id='+AppData.appIdAndroid, subject: 'Check This new Film App');
  }

  _sendMail() async{
    
    var emailAddress = 'mailto:'+AppData.email;

    if(await canLaunch(emailAddress)) {
      await launch(emailAddress);
    }   
  
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      body: Container(
        height:_height,
        width:_width,
        color: ColorList.Black,
        child: Column(
          children: <Widget>[
            //app bar
            Container(
              height: 100,
              width: _width,
              color: ColorList.Red,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom:10.0,left: 15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(
                            Icons.arrow_back,
                            color: ColorList.Black,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom:10.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),

            Container(
              height: _height -100,
              width: _width,
              child: MediaQuery.removePadding(
                context: context, 
                removeBottom: true,
                removeTop: true,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),

                    ListTile(
                      title: Text(
                        "Notification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                      trailing: Switch(
                        value: _notification,
                        inactiveTrackColor: Colors.grey,
                        activeTrackColor: ColorList.Red,
                        activeColor: Colors.white,
                        onChanged: (value) async {
                          setState(() {
                            _notification = value;
                          });
                          storage.write(key: KeyContainer.NOTIFICATION,value: _notification.toString());
                        }, 
                      ),
                    ),

                    ListTile(
                      onTap: (){
                        _rateUs();
                      },
                      title: Text(
                        "Rate Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Icon(
                          Icons.rate_review,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    ListTile(
                      onTap: (){
                        _shareWithOther();
                      },
                      title: Text(
                        "Share",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    ListTile(
                      onTap: (){
                        _sendMail();
                      },
                      title: Text(
                        "Contact Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                      subtitle: Text(
                        "Is there any thing missing let us know",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Icon(
                          Icons.contact_mail,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
