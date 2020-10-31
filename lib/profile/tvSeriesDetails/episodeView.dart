import 'package:film_app/model/episode.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../const.dart';

class EpisodeViewDownload extends StatefulWidget {
  final Episode episode;
  final String tvSeriesName;
  EpisodeViewDownload({Key key,@required this.episode,@required this.tvSeriesName}) : super(key: key);

  @override
  _EpisodeViewDownloadState createState() => _EpisodeViewDownloadState();
}

class _EpisodeViewDownloadState extends State<EpisodeViewDownload> {
  double _height = 0.0;
  double _width = 0.0;

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("cant launch");
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    padding: const EdgeInsets.only(bottom:10.0,right: 20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        child: Icon(
                          Icons.share,
                          color: ColorList.Black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom:10.0,left: 60),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        child: Text(
                          widget.tvSeriesName,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              width: _width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  widget.episode.seasonName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                widget.episode.epiName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                height: 200,
                width: _width-50,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: _width-50,
                      child: WebView(
                        initialUrl: "https://film-c6ade.web.app/",
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        print("on tap");
                        _launchURL(widget.episode.epiUrl);
                      },
                      child: Container(
                        height: 200,
                        width: _width-50,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}