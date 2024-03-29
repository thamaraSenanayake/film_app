import 'dart:async';
import 'package:film_app/auth.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:film_app/const.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/database/localDb.dart';
import 'package:film_app/model/episode.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/model/tvSerices.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/module/gridItem/gridItem.dart';
import 'package:film_app/module/gridItem/gridTitle.dart';
import 'package:film_app/profile/filmDetails/filmDetails.dart';
import 'package:film_app/profile/filmList/filmList.dart';
import 'package:film_app/profile/filmList/filmListFavourite.dart';
import 'package:film_app/profile/filmList/filmListSearch.dart';
import 'package:film_app/profile/settings.dart';
import 'package:film_app/profile/tvSericesList/tvSeriesList.dart';
import 'package:film_app/res/typeConvert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'hintDisplay.dart';


class HomePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  HomePage({Key key, this.profile}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin  implements GridItemListner,HomePageListener { 
  double _height = 0.0;
  double _width = 0.0;
  double _top = 0.0;
  double _pageHeight = 0.0;
  List<Widget> _imageList = [];
  List<Widget> _recentFilmsList = [];
  List<Widget> _newFilmsList = [];
  List<Widget> _englishFilmsList = [];
  List<Widget> _hindiFilmsList = [];
  List<Widget> _tamilFilmsList = [];
  List<Widget> _koreanFilmsList = [];
  

  Timer timer;
  ScrollController _controller;
  bool _onTop = true;
  
  bool _recentViewFilms = false;
  bool _newlyAddedFilms = false;
  bool _englishFilms = false;
  bool _hindiFilms = false;
  bool _tamilFilms = false;
  bool _koreanFilms = false;
  bool _showSearchText = false;
  
  bool _isLoading = false;

  FancyDrawerController _fancyController;
  final _searchController = TextEditingController();
  final storage = new FlutterSecureStorage();
  Database database = Database();

 
  @override
  void initState() {
    super.initState();
    _fancyController = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      _loadSlider();
      _loadFilms();
      _hintDisplay();
    });

    _initNotification();
    // _addTvSerices();
  }

  _initNotification(){
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  _addTvSerices(){
    List<Episode> epiList = [];
    epiList.add(
      Episode(
        seasonName:"season one",
        epiUrl:"https://stackoverflow.com/questions/734689/sqlite-primary-key-on-multiple-columns",
      )
    );
    epiList.add(
      Episode(
        seasonName:"season one",
        epiUrl:"https://stackoverflow.com/questions/734689/sqlite-primary-key-on-multiple-columns",
      )
    );
    epiList.add(
      Episode(
        seasonName:"season one",
        epiUrl:"https://stackoverflow.com/questions/734689/sqlite-primary-key-on-multiple-columns",
      )
    );
    epiList.add(
      Episode(
        seasonName:"season Two",
        epiUrl:"https://stackoverflow.com/questions/734689/sqlite-primary-key-on-multiple-columns",
      )
    );


    TvSeries tvSeries = TvSeries(
      name:"The Witcher",
      year:"2019",
      imgUrl:"https://m.media-amazon.com/images/M/MV5BOGE4MmVjMDgtMzIzYy00NjEwLWJlODMtMDI1MGY2ZDlhMzE2XkEyXkFqcGdeQXVyMzY0MTE3NzU@._V1_UX182_CR0,0,182,268_AL_.jpg",
      ratings:7.8,
      description:"Geralt of Rivia, a solitary monster hunter, struggles to find his place in a world where people often prove more wicked than beasts.",
      lanuage:FilmListCategery.English,
      videoUrl:"https://www.youtube.com/watch?v=ndl1W4ltcmg",
      episodeList:epiList,
    );

    database.addTvSeries(tvSeries);
  }

  _hintDisplay() async {
    String hint = await storage.read(key: KeyContainer.HINTDISPLAY);
    if(hint!="false"){
      Navigator.of(context).push(HintDisplay());
      await storage.write(key: KeyContainer.HINTDISPLAY,value: "false");
    }
  }

  // _loadRecentFilmsList() async{
    // List<Film> recentFilm = database.r
  // }
  _loadNewFilmsList(int filmLength) async{
    List<Widget> _newFilmsListTemp = [];
    List<Film> newFilm =await  database.newFilms(5);

    _newFilmsListTemp.add(GridHeader(title: "Newly Added Films",index: 0,filmListCategery:FilmListCategery.NewlyAdd,gridItemListner:this));

    for (var i = 0; i < filmLength; i++) {
      _newFilmsListTemp.add(
        GridItem(film: newFilm[i], gridItemListener: this, index: i+1)
      );
    } 

    setState(() {
      _newFilmsList =  _newFilmsListTemp;
    });

  }

  _loadEnglishFilmsList(int filmLength) async {
    List<Film> englishFilm =await  database.loadByLanguageFilms(FilmListCategery.English);
    List<Widget> _englishFilmsListTemp = [];
    _englishFilmsListTemp.add(GridHeader(title: "English Films",index: 0,filmListCategery:FilmListCategery.English,gridItemListner:this));

    for (var i = 0; i < filmLength; i++) {
      _englishFilmsListTemp.add(
        GridItem(film: englishFilm[i], gridItemListener: this, index: i+1)
      );
    }
    setState(() {
      _englishFilmsList =  _englishFilmsListTemp;
    });
  }

  _loadHindiFilmsList(int filmLength) async {
    List<Film> hindiList =await database.loadByLanguageFilms(FilmListCategery.Hindi);
    List<Widget> _hindiFilmsListTemp = [];
    _hindiFilmsListTemp.add(GridHeader(title: "Hindi Films",index: 0,filmListCategery:FilmListCategery.Hindi,gridItemListner:this));
    for (var i = 0; i < filmLength; i++) {
      _hindiFilmsListTemp.add(
        GridItem(film: hindiList[i], gridItemListener: this, index: i+1)
      );
    }

    setState(() {
      _hindiFilmsList =  _hindiFilmsListTemp;
    });

  } 
  _loadTamilFilmsList(int filmLength) async {
    List<Film> tamilFilm =await  database.loadByLanguageFilms(FilmListCategery.Tamil);

    List<Widget> _tamilFilmsListTemp = [];
    _tamilFilmsListTemp.add(GridHeader(title: "Tamil Films",index: 0,filmListCategery:FilmListCategery.Tamil,gridItemListner:this));
    for (var i = 0; i < filmLength; i++) {
      _tamilFilmsListTemp.add(
        GridItem(film: tamilFilm[i], gridItemListener: this, index: i+1)
      );
    }
    setState(() {
      _tamilFilmsList =  _tamilFilmsListTemp;
    });
  }
  _loadKoreanFilmsList(int filmLength) async {
    List<Film> koreanFilm =await database.loadByLanguageFilms(FilmListCategery.Korean);

    List<Widget> _koreanFilmsListTemp = [];
    _koreanFilmsListTemp.add(GridHeader(title: "Korean Films",index: 0,filmListCategery:FilmListCategery.Korean,gridItemListner:this));
    for (var i = 0; i < filmLength; i++) {
      _koreanFilmsListTemp.add(
        GridItem(film: koreanFilm[i], gridItemListener: this, index: i+1)
      );
    }
    setState(() {
      _koreanFilmsList =  _koreanFilmsListTemp;
    });
  }

  _loadFilms() async {
    int filmLength=0;
    
    List<Widget> _recentFilmsListTemp = [];
    
    
    if(_height - 210< _width*1.5){
      setState(() {
        filmLength = 3;
      });
    }else{
      setState(() {
        filmLength = 5;
      });
    }

    _loadNewFilmsList(filmLength);
    _loadEnglishFilmsList(filmLength);
    _loadHindiFilmsList(filmLength);
    _loadKoreanFilmsList(filmLength);
    _loadTamilFilmsList(filmLength);

    _recentFilmsListTemp.add(GridHeader(title: "Recently Viewed Films",index: 0,filmListCategery:FilmListCategery.RecentlyView,gridItemListner:this));
    List<Film> _recentFilm = await DBProvider.db.recentFilmList();
    print("_recentFilm");
    print(_recentFilm.length);
    if(_recentFilm.length >=  filmLength){
      for (var i = 0; i < filmLength; i++) {
        _recentFilmsListTemp.add(
          GridItem(film: _recentFilm[i], gridItemListener: this, index: i+1)
        );
      }
    }
    setState(() {
      _recentFilmsList = _recentFilmsListTemp;
    });
  }

  _goDownButtonClick(){
    _controller.jumpTo(_pageHeight);
    setState(() {
      _onTop = false;
      _recentViewFilms = true;
    });
  }

  _scrollListener(){
    // if(_controller.position.pixels < 20){
    //   setState(() {
    //     _onTop = true;
    //   });
    // }
    if(ScrollDirection.reverse == _controller.position.userScrollDirection ){
      if(_controller.position.pixels > (_pageHeight)*5+40 && !_koreanFilms){
        _controller.animateTo((_pageHeight)*6,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _koreanFilms = true;
        });
      }
      else if(_controller.position.pixels > (_pageHeight)*4+40 && !_tamilFilms){
        _controller.animateTo((_pageHeight)*5,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _tamilFilms = true;
        });
      }
      else if(_controller.position.pixels > (_pageHeight)*3+40 && !_hindiFilms){
        _controller.animateTo((_pageHeight)*4,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _hindiFilms = true;
        });
      }
      else if(_controller.position.pixels > (_pageHeight)*2+40 && !_englishFilms){
        _controller.animateTo((_pageHeight)*3,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _englishFilms = true;
        });
      }
      else if(_controller.position.pixels > _pageHeight + 40 &&!_newlyAddedFilms ){
        _controller.animateTo((_pageHeight)*2,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _newlyAddedFilms = true;
        });
      }
      else if(_controller.position.pixels > 40 && _onTop ){
        _controller.animateTo(_pageHeight,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _onTop = false;
          _recentViewFilms = true;
        });
      }
    }else{
      if(_controller.position.pixels < _pageHeight -40 && !_onTop ){
        print(1);
        _controller.animateTo(0,duration: Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {
          _onTop = true;
          _recentViewFilms = false;
        });
      }
      else if(_controller.position.pixels < _pageHeight*2 -40 && _newlyAddedFilms ){
        print(2);
        _controller.animateTo(_pageHeight,duration: Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {
          _newlyAddedFilms = false;
        });
      }
      else if(_controller.position.pixels < _pageHeight*3 -40 && _englishFilms ){
        print(3);
        _controller.animateTo(_pageHeight*2,duration: Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {
          _englishFilms = false;
        });
      }
      else if(_controller.position.pixels < _pageHeight*4 -40 && _hindiFilms ){
        print(4);
        _controller.animateTo(_pageHeight*3,duration: Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {
          _hindiFilms = false;
        });
      }
      else if(_controller.position.pixels < _pageHeight*5 -40 && _tamilFilms ){
        print(5);
        _controller.animateTo(_pageHeight*4,duration: Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {
          _tamilFilms = false;
        });
      }
      else if(_controller.position.pixels < _pageHeight*6 -40 && _koreanFilms ){
        print(5);
        _controller.animateTo(_pageHeight*5,duration: Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {
          _koreanFilms = false;
        });
      }
      
    }

  }

  _loadSlider() async{
    List<Film> topFilmList = await database.getTopFiveFilms();
    List<Widget> _imageListTemp = [];
    for (var item in topFilmList) {
      _imageListTemp.add(
        GestureDetector(
          onTap: (){
            gridItemListner(item);
          },
          child: Container(
            height: _height - 100,
            width: _width,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Container(
                  height: _height - 100,
                  width: _width,
                  child: Image.network(
                    item.imgUrl,
                    fit: BoxFit.cover
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    width: _width,
                    decoration: BoxDecoration(
                      color: ColorList.Black.withOpacity(0.5),
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
                                item.name,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: item.ratings.toString()+'/ ',
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filmLanguageToString(item.lanuage) +" - "+filmGenaricToString(item.genaric),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  gridItemListner(item);
                                },
                                child: Container(
                                  child: Text(
                                    "More details ...",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
  _search(){
    if(_searchController.text.isNotEmpty){
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => FilmListSearch(searchKey:_searchController.text),
          opaque: false
        ),
      );
    }
    setState(() {
      _showSearchText = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
      _pageHeight = _height - 100;
    });
    return Material(
      
      child: FancyDrawerWrapper(
        backgroundColor: ColorList.Black,
        controller: _fancyController,
        drawerItems: <Widget>[
          Container(
            height: 150,
            width: 150,
            child: Image.asset(
              'assets/image/film.png'
            ),
          ),
          widget.profile != null? Container(
            height: 70,
            width: 190,
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    widget.profile["photoUrl"],
                  ),
                ),
                SizedBox(
                  width:20 ,
                ),
                Container(
                  height: 70,
                  width: 100,
                  child: Column(
                    children: [
                      Text(
                        widget.profile["displayName"],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )

              ],
            ),
          ):Container(),
          GestureDetector(
            onTap: (){
              _fancyController.close();
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width:10
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => FilmListFavorite(),
                  opaque: false
                ),
              );
              _fancyController.close();
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width:10
                  ),
                  Text(
                    "Favorite",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => Settings(),
                  opaque: false
                ),
              );
              _fancyController.close();
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width:10
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              authservice.googleSignIn();
              _fancyController.close();
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width:10
                  ),
                  Text(
                    widget.profile == null? "Login":"Logout",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        child: Scaffold(
          body: Container(
            height:_height,
            width:_width,
            child: Stack(
              children: <Widget>[
                Container(
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
                                      print("open");
                                      _fancyController.toggle();
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.menu,
                                        color: ColorList.Black,
                                        size: 28,
                                      ),
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
                                        _showSearchText = true;
                                      });
                                    },
                                    child: Container(
                                      child: Icon(
                                        Icons.search,
                                        color: ColorList.Black,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              _showSearchText? Padding(
                                padding: const EdgeInsets.only(bottom:10.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: _width -10,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 2.0,
                                          spreadRadius: -2.0, 
                                          offset: Offset(
                                            2.0,
                                            2.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: _width-110,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:20.0),
                                            child: TextField(
                                              style: TextStyle(color: Colors.black, fontSize: 15),
                                              controller: _searchController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Search...",
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
                                                _search();
                                              },
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            _search();
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: ColorList.Black,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(3),
                                                bottomRight: Radius.circular(3),
                                              )
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Search",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.8,
                                                  color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ):Container(),

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
                                      viewportFraction:1,
                                      autoPlayAnimationDuration: Duration(seconds:3)
                                    ),
                                    items: _imageList,
                                  ),
                                ),

                                //recently view films
                                Container(
                                  height: _height-100,
                                  width: _width,
                                  // color: Colors.red,
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
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => FilmList(
                                                          filmListCategery: FilmListCategery.English,
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => FilmList(
                                                          filmListCategery: FilmListCategery.Hindi,
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => FilmList(
                                                          filmListCategery: FilmListCategery.Tamil,
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => FilmList(
                                                          filmListCategery: FilmListCategery.Telugu,
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                                          "Telugu",
                                                          style:TextStyle(
                                                            color: ColorList.Black,
                                                            fontSize: 15
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => FilmList(
                                                          filmListCategery: FilmListCategery.Korean,
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => TvSeriesList(
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                                          "TV Series",
                                                          style:TextStyle(
                                                            color: ColorList.Black,
                                                            fontSize: 15
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder: (context, _, __) => FilmList(
                                                          filmListCategery: FilmListCategery.Other,
                                                          listener: this,
                                                        ),
                                                        opaque: false
                                                      ),
                                                    );
                                                  },
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
                                                          "Other",
                                                          style:TextStyle(
                                                            color: ColorList.Black,
                                                            fontSize: 15
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      _recentViewFilms?Container(
                                        width: _width,
                                        // height: _height-210,
                                        height:_height -210,
                                        // color: Colors.amber,
                                        child: AnimationLimiter(
                                          child: GridView.count(
                                            primary: false,
                                            // padding: const EdgeInsets.all(20),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            children:_recentFilmsList.length != 1?_recentFilmsList:_newFilmsList
                                            
                                          ),
                                        ),
                                      ):
                                      Container(
                                        width: _width,
                                        height: _height-210,
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
                                        height: _height -210,
                                        // color: Colors.amber,
                                        child: AnimationLimiter(
                                          child: GridView.count(
                                            primary: false,
                                            // padding: const EdgeInsets.all(20),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            children:_recentFilmsList.length != 1?_newFilmsList:_englishFilmsList,
                                          ),
                                        ),
                                      ):
                                      Container(
                                        width: _width,
                                        height: _height -210,
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
                                        height: _height -210,
                                        // color: Colors.amber,
                                        child: AnimationLimiter(
                                          child: GridView.count(
                                            primary: false,
                                            // padding: const EdgeInsets.all(20),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            children:_recentFilmsList.length != 1?_englishFilmsList:_hindiFilmsList,
                                          ),
                                        ),
                                      ):
                                      Container(
                                        width: _width,
                                        height: _height -210,
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
                                        height: _height -210,
                                        // color: Colors.amber,
                                        child: AnimationLimiter(
                                          child: GridView.count(
                                            primary: false,
                                            // padding: const EdgeInsets.all(20),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            children:_recentFilmsList.length != 1? _hindiFilmsList:_tamilFilmsList,
                                          ),
                                        ),
                                      ):
                                      Container(
                                        width: _width,
                                        height: _height -210,
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),

                                //tamil films
                                Container(
                                  height: _height-100,
                                  width: _width,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      _tamilFilms?Container(
                                        width: _width,
                                        height: _height -210,
                                        // color: Colors.amber,
                                        child: AnimationLimiter(
                                          child: GridView.count(
                                            primary: false,
                                            // padding: const EdgeInsets.all(20),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            children:_recentFilmsList.length != 1? _tamilFilmsList:_koreanFilmsList,
                                          ),
                                        ),
                                      ):
                                      Container(
                                        width: _width,
                                        height: _height -210,
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),

                                //korean films
                                _recentFilmsList.length != 1?Container(
                                  height: _height-100,
                                  width: _width,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      _koreanFilms?Container(
                                        width: _width,
                                        height: _height -210,
                                        // color: Colors.amber,
                                        child: AnimationLimiter(
                                          child: GridView.count(
                                            primary: false,
                                            // padding: const EdgeInsets.all(20),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            crossAxisCount: 2,
                                            children: _koreanFilmsList,
                                          ),
                                        ),
                                      ):
                                      Container(
                                        width: _width,
                                        height: _height -210,
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ):Container()
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),

               _onTop? AnimatedPositioned(
                  top:_top,
                  right: 10,
                  duration: Duration(seconds: 1),
                  child: GestureDetector(
                    onTap: (){
                      _goDownButtonClick();
                    },
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
                  ),
                ):Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  gridItemListner(Film film) {
    DBProvider.db.addRecentlyViewFilm(film); 
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => FilmDetails(
          film: film,
          profile: widget.profile,
        ),
        opaque: false
      ),
    );
  }

  @override
  gridItemTitleClick(FilmListCategery filmListCategery) {
    print(filmListCategery);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => FilmList(
          filmListCategery: filmListCategery,
          listener: this,
        ),
        opaque: false
      ),
    );
  }

  @override
  reloadFilms() {
    _loadFilms();
  }

  @override
  gridItemTVSerriesListener(TvSeries tvSeries) {
    
  }
}

abstract class HomePageListener{
  reloadFilms();
}
