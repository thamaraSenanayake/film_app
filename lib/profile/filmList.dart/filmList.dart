import 'package:awesome_loader/awesome_loader.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/module/gridItem/gridItem.dart';
import 'package:film_app/profile/filmDetails/filmDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../const.dart';

class FilmList extends StatefulWidget {
  final FilmListCategery filmListCategery;
  FilmList({Key key,@required this.filmListCategery}) : super(key: key);

  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> implements GridItemListner{
  double _height = 0.0;
  double _width = 0.0;
  bool _genaricDisplay = false;
  bool _showSearchText = false;
  ScrollController _controller;
  String _title = "";
  final _searchController = TextEditingController();
  FilmGenaricList filmGenaricList = FilmGenaricList.All;
  bool _loading = true;
  List<Widget> _filmListWidget =[];
  Database database = Database(); 
  List<Film> _filmList = [];

  _search(){
    setState(() {
      _showSearchText = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _setTitle();
    _loadFilms();
  }

  _scrollListener(){
    print(_controller.position.atEdge);
    print(_controller.position.userScrollDirection);
    if(_controller.position.atEdge && _controller.position.userScrollDirection == ScrollDirection.reverse){
      _nextFilm();
    }
  }

  _nextFilm() async {
    List<Widget> _filmListWidgetTemp =[]; 
    List<Film> _filmListTemp = [];

    if(widget.filmListCategery == FilmListCategery.NewlyAdd ){
      if(filmGenaricList == FilmGenaricList.All){
        _filmListTemp.addAll(await database.newFilmsNext(AppData.pagesize));
      }else{
        _filmListTemp.addAll(await database.newMoviesWithGenaricNext(filmGenaricList,AppData.pagesize));
      }
    }else{
      if(filmGenaricList == FilmGenaricList.All){
        _filmListTemp.addAll(await database.allMoviesNext(widget.filmListCategery, AppData.pagesize));
      }else{
        _filmListTemp.addAll(await database.moviesWithGenaricNext(widget.filmListCategery,filmGenaricList, AppData.pagesize));
      }
    }

    
     _filmList.addAll(_filmListTemp);


    for (var item in _filmList) {
      _filmListWidgetTemp.add(
        GridItem(film: item, gridItemListner: this, index: _filmList.indexOf(item))
      );
    }

    if(_filmListTemp.length == AppData.pagesize){
      _filmListWidgetTemp.add(
        AwesomeLoader(
          loaderType: AwesomeLoader.AwesomeLoader3,
          color: ColorList.Red,
        ),
      );
    }
    
    setState(() {
      _filmListWidget = _filmListWidgetTemp;
      _loading = false;
    });
  }

  _loadFilms() async{
    _filmList = [];
    List<Widget> _filmListWidgetTemp =[]; 
    
    if(widget.filmListCategery == FilmListCategery.NewlyAdd ){
      _filmList = await database.newFilms(AppData.pagesize);
    }else{
      _filmList = await database.allMovies(widget.filmListCategery, AppData.pagesize);
    }
    for (var item in _filmList) {
      _filmListWidgetTemp.add(
        GridItem(film: item, gridItemListner: this, index: _filmList.indexOf(item))
      );
    }
    if(_filmList.length == AppData.pagesize){
      _filmListWidgetTemp.add(
        AwesomeLoader(
          loaderType: AwesomeLoader.AwesomeLoader3,
          color: ColorList.Red,
        ),
      );
    }
    setState(() {
      _filmListWidget = _filmListWidgetTemp;
      _loading = false;
    });

  }

  _loadGenaric() async {
    List<Widget> _filmListWidgetTemp =[]; 
    _filmList = [];
    if(widget.filmListCategery == FilmListCategery.NewlyAdd){
      _filmList = await database.newMoviesWithGenaric(filmGenaricList, AppData.pagesize);
    }else{
      _filmList = await database.moviesWithGenaric(widget.filmListCategery,filmGenaricList, AppData.pagesize);
    }
    for (var item in _filmList) {
      _filmListWidgetTemp.add(
        GridItem(film: item, gridItemListner: this, index: _filmList.indexOf(item))
      );
    }
    if(_filmList.length == AppData.pagesize){
      _filmListWidgetTemp.add(
        AwesomeLoader(
          loaderType: AwesomeLoader.AwesomeLoader3,
          color: ColorList.Red,
        ),
      );
    }
    setState(() {
      _filmListWidget = _filmListWidgetTemp;
      _loading = false;
    });
  }

  _setTitle(){
    if (FilmListCategery.RecentlyView == widget.filmListCategery){
      setState(() {
        _title = "Recently View";
      });
    }
    else if (FilmListCategery.NewlyAdd == widget.filmListCategery){
      setState(() {
        _title = "Newly Add";
      });
    }
    else if (FilmListCategery.English == widget.filmListCategery){
      setState(() {
        _title = "English";
      });
    }
    else if (FilmListCategery.Tamil == widget.filmListCategery){
      setState(() {
        _title = "Tamil";
      });
    }
    else if (FilmListCategery.Korean == widget.filmListCategery){
      setState(() {
        _title = "Korean";
      });
    }
    else if (FilmListCategery.Hindi == widget.filmListCategery){
      setState(() {
        _title = "Hindi";
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
                          _title,
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
                child: ListView(
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
                                  setState(() {
                                    filmGenaricList = FilmGenaricList.All;
                                    _loading = true;
                                  });
                                  _loadFilms();
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3)
                                    ),
                                    color: filmGenaricList == FilmGenaricList.All? ColorList.Red:Colors.white
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "All",
                                        style:TextStyle(
                                          color: filmGenaricList == FilmGenaricList.All? Colors.white:ColorList.Black,
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
                                  setState(() {
                                    filmGenaricList = FilmGenaricList.Action;
                                    _loading = true;
                                  });
                                  _loadGenaric();
                                  
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3)
                                    ),
                                    color: filmGenaricList == FilmGenaricList.Action? ColorList.Red:Colors.white
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Action",
                                        style:TextStyle(
                                          color: filmGenaricList == FilmGenaricList.Action? Colors.white:ColorList.Black,
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
                                  setState(() {
                                    filmGenaricList = FilmGenaricList.Advenure;
                                  _loading = true;
                                  });
                                  _loadGenaric();
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3)
                                    ),
                                    color: filmGenaricList == FilmGenaricList.Advenure? ColorList.Red:Colors.white
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Adventure",
                                        style:TextStyle(
                                          color: filmGenaricList == FilmGenaricList.Advenure? Colors.white:ColorList.Black,
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
                                  setState(() {
                                    filmGenaricList = FilmGenaricList.Horror;
                                  _loading = true;
                                  });
                                  _loadGenaric();
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3)
                                    ),
                                    color: filmGenaricList == FilmGenaricList.Horror? ColorList.Red:Colors.white
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Horror",
                                        style:TextStyle(
                                          color: filmGenaricList == FilmGenaricList.Horror? Colors.white:ColorList.Black,
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
                                  setState(() {
                                    filmGenaricList = FilmGenaricList.Crime;
                                  _loading = true;
                                  });
                                  _loadGenaric();
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3)
                                    ),
                                    color: filmGenaricList == FilmGenaricList.Crime? ColorList.Red:Colors.white
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Crime",
                                        style:TextStyle(
                                          color: filmGenaricList == FilmGenaricList.Crime? Colors.white:ColorList.Black,
                                          fontSize: 15
                                        )
                                      ),
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

                    _loading?Container(
                      height: _height,
                      width: _width,
                      color: ColorList.Black.withOpacity(0.5),
                      child:AwesomeLoader(
                        loaderType: AwesomeLoader.AwesomeLoader3,
                        color: ColorList.Red,
                      ),
                    ):
                    Container(
                      height: _height -190,
                      width: _width,
                      child: AnimationLimiter(
                        child: GridView.count(
                          controller:_controller,
                          primary: false,
                          // padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 2,
                          children: _filmListWidget
                        ),
                      ),
                    ),
                    
                    // Container(
                    //           height: 50,
                    //           width: _width,
                    //           child: Align(
                    //             alignment: Alignment.centerRight,
                    //             child: Container(
                    //               decoration: BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 color: ColorList.Red
                    //               ),
                    //               child: Padding(
                    //                 padding: EdgeInsets.all(4),
                    //                 child: Icon(
                    //                   Icons.arrow_forward,
                    //                   color: ColorList.Black,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         )

                  ],
                )
              ),
            ),
          ],
        ),

      ),
    );
  }

  @override
  gridItemListner(Film film) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => FilmDeatils(
          film: film,
        ),
        opaque: false
      ),
    );
  }

  @override
  gridItemTitleClick(FilmListCategery filmListCategery) {
    
  }
}
