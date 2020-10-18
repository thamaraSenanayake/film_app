import 'package:awesome_loader/awesome_loader.dart';
import 'package:film_app/auth.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/database/localDb.dart';
import 'package:film_app/model/comment.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/module/comment/commetView.dart';
import 'package:film_app/module/relatedMovie/relatedMovieItem.dart';
import 'package:film_app/module/relatedMovie/relatedMovieListner.dart';
import 'package:film_app/profile/filmDetails/fullScreenVideo.dart';
import 'package:film_app/res/typeConvert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../const.dart';

class FilmDetails extends StatefulWidget {
  final Film film;
  final Map<String, dynamic> profile;
  FilmDetails({Key key,@required this.film, this.profile}) : super(key: key);

  @override
  _FilmDetailsState createState() => _FilmDetailsState();
}

class _FilmDetailsState extends State<FilmDetails> implements RelatedMovieListener {
  double _height = 0.0;
  double _width = 0.0;
  List<Widget> _commentListWidget = [];
  List<Widget> _relatedFilmList = [];
  List<Comment> _commentList = [];
  final _commentController = TextEditingController();
  Database database = Database();
  bool _isFavorite = false;
  Film _film;
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
    _film = widget.film;
    _controller = YoutubePlayerController(
      initialVideoId: _film.videoUrl.split("=")[1],
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    _loadData();
  }

  _loadData() async {
    _film = _film;
    if(_film.commentList == null){
      _film = await database.getMovie(_film.id);
    }
    _loadComment();
    _relatedFilmLoad();
    _favoriteCheck();

  }

  _favoriteCheck() async{
    _isFavorite = await DBProvider.db.isLiked(_film);
    setState(() {
      
    });
    print(_isFavorite);
  }

  _relatedFilmLoad() async {
    List<Widget> _relatedFilmListTemp = [];
    List<Film> _filmList = await database.moviesWithGenaric(_film.lanuage, _film.genaric, 3);
    
    for (var item in _filmList) {
      _relatedFilmListTemp.add(
        RelatedMovieView(film:item,listener: this,)
      );
    }
    setState(() {
      _relatedFilmList = _relatedFilmListTemp;
    });

  }

  _loadComment(){
    _commentList = _film.commentList;
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
      database.addComment(_commentList, _film.id.toString());
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
                            DBProvider.db.likeUnLikeFilm(_film, _isFavorite== true?1:0);
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
                            _film.name,
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
                                  Container(
                                    width:_width,
                                    height: 200,
                                    color: Colors.indigo,
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
                                          _film.imgUrl,
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
                                                videoUrl: _film.videoUrl,
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
                                              _film.name,
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
                                                        text: _film.ratings.toString()+" / ",
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
                                                        filmLanguageToString(_film.lanuage) +" - "+ filmGenaricToString(_film.genaric),
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
                                  _film.description,
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
                                        _launchURL(_film.filmUrl);
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

                            Padding(
                              padding: EdgeInsets.only(left: 10,top:20),
                              child: Text(
                                "Related Movies",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Container(
                              height: 150,
                              width: _width,
                              child: MediaQuery.removePadding(
                                context: context, 
                                removeTop: true,
                                removeBottom: true,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: _relatedFilmList
                                )
                              ),
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
  relatedMovieClick(Film film) async {
    print("click");
    setState(() {
      _loading = true;
    });
    await new Future.delayed(const Duration(seconds : 1));
    setState(() {
      _loading = false;
      _film = film;
    });
  }
}