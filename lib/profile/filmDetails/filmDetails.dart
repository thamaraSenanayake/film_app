import 'package:film_app/model/comment.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/module/comment/commetView.dart';
import 'package:film_app/module/relatedMovie/relatedMovieItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../const.dart';

class FilmDeatils extends StatefulWidget {
  final Film film;
  FilmDeatils({Key key,@required this.film}) : super(key: key);

  @override
  _FilmDeatilsState createState() => _FilmDeatilsState();
}

class _FilmDeatilsState extends State<FilmDeatils> {
  double _height = 0.0;
  double _width = 0.0;
  List<Widget> _commentListwidget = [];
  List<Widget> _relatedFilmList = [];
  List<Comment> _commentList = [];
  final _commentController = TextEditingController();

  YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'D86RtevtfrA',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
  );

  @override
  void initState() { 
    super.initState();
    _loadCommnet();
    _relatedFilmLoad();
  }

  _relatedFilmLoad(){
    List<Widget> _relatedFilmListTemp = [];
    List<Film> _filmList = [];
    
    _filmList.add(Film(imgUrl:'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg',name: "film Name",ratings: 7.8,genaric: "Action",lanuage: "English"));
    _filmList.add(Film(imgUrl:'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png',name: "film Name",ratings: 7.8,genaric: "Action",lanuage: "English"));
    _filmList.add(Film(imgUrl:'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg',name: "film Name",ratings: 7.8,genaric: "Action",lanuage: "English"));
    _filmList.add(Film(imgUrl:'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690',name: "film Name",ratings: 7.8,genaric: "Action",lanuage: "English"));
    _filmList.add(Film(imgUrl:'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg',name: "film Name",ratings: 7.8,genaric: "Action",lanuage: "English"));

    for (var item in _filmList) {
      _relatedFilmListTemp.add(
        RelatedMovieView(film:item)
      );
    }
    setState(() {
      _relatedFilmList = _relatedFilmListTemp;
    });

  }

  _loadCommnet(){
    _commentList.add(
      Comment(
        firstName: "Nimal",
        lastName: "Perera",
        comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      )
    );
    _displayCommnet();
  }

  _displayCommnet(){
    List<Widget> _commentListwidgetTemp = [];
    for (var item in _commentList) {
      _commentListwidgetTemp.add(
        CommentView(comment:item)
      );
    }

    setState(() {
      _commentListwidget = _commentListwidgetTemp;
    });

  }

  _postCommnet(){
    if(_commentController.text.isNotEmpty){
      _commentList.add(
        Comment(
          firstName: "First name",
          lastName: "Last name ",
          comment: _commentController.text
        )
      );
      _commentController.text = "";
      FocusScope.of(context).unfocus();
      _displayCommnet();
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
                        child: Container(
                          child: Icon(
                            Icons.favorite_border,
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
                            widget.film.name,
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
                              height: _height/2 - 100,
                              
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width:_width,
                                    height: _height/2-200,
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
                                          widget.film.imgUrl,
                                          fit: BoxFit.cover,
                                        ),
                                        
                                      ),
                                    ),
                                  ),

                                  //filem name
                                  Padding(
                                    padding: EdgeInsets.only(left:158,top:_height/2-200),
                                    child: Container(
                                      height: 100,
                                      width: _width - 158,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              widget.film.name,
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
                                                        text: widget.film.ratings.toString()+" / ",
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
                                                        widget.film.lanuage +" - "+widget.film.genaric,
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
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum ",
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
                                child: WebView(
                                  initialUrl: "https://film-c6ade.web.app",
                                  javascriptMode: JavascriptMode.unrestricted,
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
                                  children: _commentListwidget
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
                                                _postCommnet();
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              _postCommnet();
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
}