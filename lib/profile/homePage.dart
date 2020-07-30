import 'dart:async';

import 'package:film_app/const.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/module/gridItem/gridItem.dart';
import 'package:film_app/module/gridItem/gridTitle.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final List<String> imgList = [
  'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg',
  'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png',
  'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg',
  'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690',
  'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg',
];
class _HomePageState extends State<HomePage> implements GridItemListner{
  double _height = 0.0;
  double _width = 0.0;
  double _top = 0.0;
  List<Widget> _imageList = [];
  Timer timer;
  ScrollController _controller;
  bool _onTop = true;
  
  bool _recentViewFilms = false;
  bool _newlyAddedFilms = false;
  bool _englishFilms = false;
  bool _hindiFilms = false;
  bool _tamilFilms = false;
  bool _koreanFilms = false;

 
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      _loadSlider();
    });
  }

  _scrollListener(){
    print(_controller.position.userScrollDirection);
    if(_controller.position.pixels < 20){
      setState(() {
        _onTop = true;
      });
    }
    if(ScrollDirection.reverse == _controller.position.userScrollDirection ){
      if(_controller.position.pixels > (_height - 100)*2+40 && !_englishFilms){
        _controller.animateTo((_height - 100)*3,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _englishFilms = true;
        });
      }
      else if(_controller.position.pixels > _height + 40 &&!_newlyAddedFilms ){
        _controller.animateTo((_height - 100)*2,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _newlyAddedFilms = true;
        });
      }
      else if(_controller.position.pixels > 40 && _onTop ){
        _controller.animateTo(_height - 100,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _onTop = false;
          _recentViewFilms = true;
        });
      }
    }else{
      if(_controller.position.pixels < _height -40 && !_onTop ){
        _controller.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _onTop = true;
          // _recentViewFilms = false;
        });
      }
    }

  }

  _loadSlider(){
    List<Widget> _imageListTemp = [];
    for (var item in imgList) {
      _imageListTemp.add(
        Container(
          height: _height - 100,
          width: _width,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                height: _height - 100,
                width: _width,
                child: Image.network(
                  item,
                  fit: BoxFit.cover
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  width: _width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        ColorList.Black,
                        ColorList.Black.withOpacity(0.5), 
                        ColorList.Black.withOpacity(0.9), 
                      ]
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Film Name",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '7.7 / ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '10', 
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Text(
                          "English - Action",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      );

      setState(() {
        _imageList = _imageListTemp;
      });
    }

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _changeButtonPosition());
  }

  _changeButtonPosition(){
    if(_top == _height-180){
      setState(() {
        _top = _height-150;
      });
    }else{
      setState(() {
        _top = _height-180;
      });
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
        child: Stack(
          children: <Widget>[
            Container(
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
                            child: Container(
                              child: Icon(
                                Icons.menu,
                                color: ColorList.Black,
                                size: 28,
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
                                "Film App",
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

                  //page container
                  Container(
                    height: _height - 100,
                    width: _width,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView(
                        controller: _controller,
                        children: <Widget>[
                          Container(
                            height: _height - 100,
                            width: _width,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                height: _height - 100,
                                viewportFraction:1
                              ),
                              items: _imageList,
                            ),
                          ),

                          //recently view films
                          Container(
                            height: _height-100,
                            width: _width,
                            // color: Colors.amber,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 50,
                                  width: _width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:0.0),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3)
                                              ),
                                              color: Colors.white
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "English",
                                                  style:TextStyle(
                                                    color: ColorList.Black,
                                                    fontSize: 15
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3)
                                              ),
                                              color: Colors.white
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Hindi",
                                                  style:TextStyle(
                                                    color: ColorList.Black,
                                                    fontSize: 15
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3)
                                              ),
                                              color: Colors.white
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Tamil",
                                                  style:TextStyle(
                                                    color: ColorList.Black,
                                                    fontSize: 15
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3)
                                              ),
                                              color: Colors.white
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Korean",
                                                  style:TextStyle(
                                                    color: ColorList.Black,
                                                    fontSize: 15
                                                  )
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                _recentViewFilms?Container(
                                  width: _width,
                                  height: _width*1.5,
                                  // color: Colors.amber,
                                  child: AnimationLimiter(
                                    child: GridView.count(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      crossAxisCount: 2,
                                      children: <Widget>[
                                        GridHeader(title: "Recently Viewed Films",index: 0,),
                                        GridItem(film: Film(imgUrl:'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg'), gridItemListner: this, index: 1),
                                        GridItem(film: Film(imgUrl:'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png'), gridItemListner: this, index: 2),
                                        GridItem(film: Film(imgUrl:'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg'), gridItemListner: this, index: 3),
                                        GridItem(film: Film(imgUrl:'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690'), gridItemListner: this, index: 4),
                                        GridItem(film: Film(imgUrl:'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg'), gridItemListner: this, index: 5)
                                      ],
                                    ),
                                  ),
                                ):
                                Container(
                                  width: _width,
                                  height: _width*1.5,
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),

                          //newly added films
                          Container(
                            height: _height-100,
                            width: _width,
                            // color: Colors.amber,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                _newlyAddedFilms?Container(
                                  width: _width,
                                  height: _width*1.5,
                                  // color: Colors.amber,
                                  child: AnimationLimiter(
                                    child: GridView.count(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      crossAxisCount: 2,
                                      children: <Widget>[
                                        GridHeader(title: "Newly Added Films",index: 0,),
                                        GridItem(film: Film(imgUrl:'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg'), gridItemListner: this, index: 1),
                                        GridItem(film: Film(imgUrl:'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png'), gridItemListner: this, index: 2),
                                        GridItem(film: Film(imgUrl:'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg'), gridItemListner: this, index: 3),
                                        GridItem(film: Film(imgUrl:'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690'), gridItemListner: this, index: 4),
                                        GridItem(film: Film(imgUrl:'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg'), gridItemListner: this, index: 5)
                                      ],
                                    ),
                                  ),
                                ):
                                Container(
                                  width: _width,
                                  height: _width*1.5,
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),

                          //english films
                          Container(
                            height: _height-100,
                            width: _width,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                _englishFilms?Container(
                                  width: _width,
                                  height: _width*1.5,
                                  // color: Colors.amber,
                                  child: AnimationLimiter(
                                    child: GridView.count(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      crossAxisCount: 2,
                                      children: <Widget>[
                                        GridHeader(title: "English Films",index: 0,),
                                        GridItem(film: Film(imgUrl:'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg'), gridItemListner: this, index: 1),
                                        GridItem(film: Film(imgUrl:'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png'), gridItemListner: this, index: 2),
                                        GridItem(film: Film(imgUrl:'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg'), gridItemListner: this, index: 3),
                                        GridItem(film: Film(imgUrl:'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690'), gridItemListner: this, index: 4),
                                        GridItem(film: Film(imgUrl:'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg'), gridItemListner: this, index: 5)
                                      ],
                                    ),
                                  ),
                                ):
                                Container(
                                  width: _width,
                                  height: _width*1.5,
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),

                          //Hindi films
                          Container(
                            height: _height-100,
                            width: _width,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                _hindiFilms?Container(
                                  width: _width,
                                  height: _width*1.5,
                                  // color: Colors.amber,
                                  child: AnimationLimiter(
                                    child: GridView.count(
                                      primary: false,
                                      // padding: const EdgeInsets.all(20),
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      crossAxisCount: 2,
                                      children: <Widget>[
                                        GridHeader(title: "Hindi Films",index: 0,),
                                        GridItem(film: Film(imgUrl:'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg'), gridItemListner: this, index: 1),
                                        GridItem(film: Film(imgUrl:'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png'), gridItemListner: this, index: 2),
                                        GridItem(film: Film(imgUrl:'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg'), gridItemListner: this, index: 3),
                                        GridItem(film: Film(imgUrl:'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690'), gridItemListner: this, index: 4),
                                        GridItem(film: Film(imgUrl:'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg'), gridItemListner: this, index: 5)
                                      ],
                                    ),
                                  ),
                                ):
                                Container(
                                  width: _width,
                                  height: _width*1.5,
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),

           _onTop? AnimatedPositioned(
              top:_top,
              right: 10,
              duration: Duration(seconds: 1),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: ColorList.Red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                      spreadRadius: -2.0, 
                      offset: Offset(
                        1.0,
                        2.0,
                      ),
                    )
                  ],
                ),
                child: Icon(
                  Icons.arrow_downward
                ),
              ),
            ):Container()
          ],
        ),
      ),
    );
  }

  @override
  gridItemListner(Film film) {
    
  }
}
