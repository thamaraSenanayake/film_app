import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../const.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;
  FullScreenVideo({Key key,@required this.videoUrl}) : super(key: key);
  @override

  _FullScreenVideoState createState() => _FullScreenVideoState();

}

class _FullScreenVideoState extends State<FullScreenVideo> {
  double _height = 0.0;
  double _width = 0.0;
  YoutubePlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoUrl.split("=")[1],
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      body: RotatedBox(
        quarterTurns: 1,
        child: Container(
          height:_width,
          width:_height,
          color: Colors.red,
          child: Stack(
            children: [
              Container(
                height:_width,
                width:_height,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressColors: ProgressBarColors(
                    playedColor: ColorList.Red,
                    bufferedColor:ColorList.Black,
                    backgroundColor: ColorList.Black
                  ),
                  bottomActions: <Widget>[
                  ],
                  topActions: <Widget>[],
                  onReady: () {
                      // _controller.addListener(listener);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        Icons.arrow_back,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}