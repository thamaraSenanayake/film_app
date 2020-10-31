import 'package:awesome_loader/awesome_loader.dart';
import 'package:film_app/auth.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/database/localDb.dart';
import 'package:film_app/model/comment.dart';
import 'package:film_app/model/episode.dart';
import 'package:film_app/model/tvSerices.dart';
import 'package:film_app/module/comment/commetView.dart';
import 'package:film_app/module/episode/episodeView.dart';
import 'package:film_app/profile/filmDetails/fullScreenVideo.dart';
import 'package:film_app/res/typeConvert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../const.dart';
import 'episodeView.dart';

class TvSeriesDetails extends StatefulWidget {
  final TvSeries tvSeries;
  final Map<String, dynamic> profile;
  TvSeriesDetails({Key key,@required this.tvSeries, this.profile}) : super(key: key);

  @override
  _TvSeriesStateDetails createState() => _TvSeriesStateDetails();
}

class _TvSeriesStateDetails extends State<TvSeriesDetails> implements EpisodeViewController {
  double _height = 0.0;
  double _width = 0.0;
  List<Widget> _commentListWidget = [];
  List<Widget> _seasonListWidget = [];
  List<Comment> _commentList = [];
  final _commentController = TextEditingController();
  Database database = Database();
  bool _isFavorite = false;
  TvSeries _tvSeries;
  bool _loading = false;
  
  YoutubePlayerController _controller;

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("cant launch");
    }
  }
  
  @override
  void initState() { 
    super.initState();
    _tvSeries = widget.tvSeries;
    _controller = YoutubePlayerController(
      initialVideoId: _tvSeries.videoUrl.split("=")[1],
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    _loadData();
    _loadEpisode();
  }

  _loadEpisode(){
    String _currentSeason ="";
    if(_tvSeries.episodeList.length > 0){
      _currentSeason = _tvSeries.episodeList[0].seasonName;
      List<Episode> episodeList = [];
      print(_tvSeries.episodeList.length);
      for (var item in _tvSeries.episodeList) {
        if (item.seasonName != _currentSeason) {
          _seasonListWidget.add(
            EpisodeView(episodeLit: episodeList, controller: this)
          );
          _currentSeason = item.seasonName;
          episodeList =[];
        }
        episodeList.add(item);
        
      }
      if(episodeList.length != 0){
        _seasonListWidget.add(
          EpisodeView(episodeLit: episodeList, controller: this)
        );
      }
    }
    setState(() {
      
    });
  }

  _loadData() async {
    if(_tvSeries.commentList == null){
      _tvSeries = await database.getTvSeries(_tvSeries.id);
    }
    _loadComment();
    _favoriteCheck();

  }

  _favoriteCheck() async{
    _isFavorite = await DBProvider.db.isLiked(_tvSeries.id,MainType.TvSeries);
    setState(() {
      
    });
    print(_isFavorite);
  }


  _loadComment(){
    _commentList = _tvSeries.commentList;
    _displayComment();
  }

  _displayComment(){
    List<Widget> _commentListWidgetTemp = [];
    for (var item in _commentList) {
      _commentListWidgetTemp.add(
        CommentView(comment:item)
      );
    }

    setState(() {
      _commentListWidget = _commentListWidgetTemp;
    });

  }

  _postComment(){
    if(widget.profile == null){
      authservice.googleSignIn();
      return;
    }
    if(_commentController.text.isNotEmpty){
      _commentList.add(
        Comment(
          firstName: widget.profile["displayName"].toString().split(" ")[0],
          lastName: widget.profile["displayName"].toString().split(" ")[1],
          comment: _commentController.text
        )
      );
      _commentController.text = "";
      FocusScope.of(context).unfocus();
      _displayComment();
      database.addComment(_commentList, _tvSeries.id.toString());
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
        child: SingleChildScrollView(
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
                      padding: const EdgeInsets.only(bottom:10.0,right: 60),
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
                      padding: const EdgeInsets.only(bottom:10.0,right: 15),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            DBProvider.db.likeUnLikeFilm(_tvSeries.id, _isFavorite== true?1:0,MainType.TvSeries);
                          },
                          child: Container(
                            child: Icon(
                              _isFavorite? Icons.favorite:Icons.favorite_border,
                              color: ColorList.Black,
                              size: 28,
                            ),
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
                            _tvSeries.name,
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

              //page container
              _loading?
                Container(
                width:_width,
                height: _height - 100,
                color: ColorList.Black.withOpacity(0.5),
                child:AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader3,
                  color: ColorList.Red,
                ),
              ):
              Container(
                width:_width,
                height: _height - 100,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: AnimationLimiter(
                    child: ListView(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                          children: <Widget>[
                            Container(
                              width:_width,
                              height: 250,
                              
                              child: Stack(
                                children: <Widget>[
                                  // Container(
                                  //   width:_width,
                                  //   height: 200,
                                  //   color: Colors.indigo,
                                  //   child: YoutubePlayer(
                                  //     controller: _controller,
                                  //     showVideoProgressIndicator: true,
                                  //     progressColors: ProgressBarColors(
                                  //       playedColor: ColorList.Red,
                                  //       bufferedColor:ColorList.Black,
                                  //       backgroundColor: ColorList.Black
                                  //     ),
                                  //     bottomActions: <Widget>[
                                  //     ],
                                  //     topActions: <Widget>[],
                                  //     onReady: () {
                                  //         // _controller.addListener(listener);
                                  //     },
                                  //   ),
                                  // ),

                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Align(
                                      alignment:Alignment.bottomLeft,
                                      child: Container(
                                        height: 200,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 2.0,
                                              spreadRadius: -2.0, 
                                              offset: Offset(
                                                1.0,
                                                2.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Image.network(
                                          _tvSeries.imgUrl,
                                          fit: BoxFit.cover,
                                        ),
                                        
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right:4.0,top:4),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, _, __) => FullScreenVideo(
                                                videoUrl: _tvSeries.videoUrl,
                                              ),
                                              opaque: false
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Icon(
                                            Icons.fullscreen,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //film name
                                  Padding(
                                    padding: EdgeInsets.only(left:158,top:150),
                                    child: Container(
                                      height: 100,
                                      width: _width - 158,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              _tvSeries.name,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 23,
                                                fontWeight: FontWeight.w800,
                                                wordSpacing: 1.5,
                                                letterSpacing: 1.5
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 66,
                                                  width: (_width - 158)/2,
                                                  child:Center(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: _tvSeries.ratings.toString()+" / ",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight: FontWeight.w800,
                                                          color: Colors.white,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: '10', 
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ),
                                                Container(
                                                  height: 66,
                                                  width: (_width - 158)/2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        filmLanguageToString(_tvSeries.lanuage),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //film description
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                              child: Container(
                                child:Text(
                                  _tvSeries.description,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.5,
                                    wordSpacing: 1.5,
                                    letterSpacing: 1.5
                                  ),
                                )
                              ),
                            ),

                            
                            Column(
                              children: _seasonListWidget,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10,top:20),
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Column(
                              children: <Widget>[
                                Column(
                                  children: _commentListWidget
                                ),

                                Card(
                                  child: Container(
                                    width: _width-20,
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: _width -120,
                                            child: TextField(
                                              style: TextStyle(color: Colors.black, fontSize: 15),
                                              controller: _commentController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Add Your comment here...",
                                                hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xffB3A9A9),
                                                  height: 1.8
                                                ),
                                              ),
                                              keyboardType: TextInputType.text,
                                              onChanged: (value){
                                                // _englishtitleErrorRemove();
                                              },
                                              onSubmitted: (value){
                                                _postComment();
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              _postComment();
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 50,
                                              color: ColorList.Red,
                                              child: Center(
                                                child: Text(
                                                  "Post",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]
                                      )
                                    )
                                  )
                                )

                              ],
                            ),

                            SizedBox(height: 50,)
                        
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  episodeClick(Episode episode,String epiName) {
    Episode epi = Episode(
      seasonName:episode.seasonName,
      epiUrl:episode.epiUrl,
      epiName:epiName,
    );
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => EpisodeViewDownload(
          episode: epi, 
          tvSeriesName: widget.tvSeries.name,
        ),
        opaque: false
      ),
    );
  }
}