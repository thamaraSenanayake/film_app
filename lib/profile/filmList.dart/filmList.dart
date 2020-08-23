import 'package:film_app/model/film.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/module/gridItem/gridItem.dart';
import 'package:film_app/profile/filmDetails/filmDetails.dart';
import 'package:flutter/material.dart';
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
  String _title = "";
  final _searchController = TextEditingController();
  FilmGenaricList filmGenaricList = FilmGenaricList.All;

  _search(){
    setState(() {
      _showSearchText = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _setTitle();
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
                                  });
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
                                  });
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
                                  });
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
                                  });
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
                                  });
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

                    Container(
                      height: _height -190,
                      width: _width,
                      child: AnimationLimiter(
                        child: GridView.count(
                          primary: false,
                          // padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 2,
                          children: <Widget>[
                            GridItem(film: Film(imgUrl:'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/62077a91502251.5e332b479a8d3.jpg',name: "film Name",ratings: 7.8,genaric: FilmGenaricList.Action,lanuage: FilmListCategery.English), gridItemListner: this, index: 0),
                            GridItem(film: Film(imgUrl:'https://www.joblo.com/assets/images/joblo/posters/2019/08/1vso0vrm42j31.jpg',name: "film Name",ratings: 7.8,genaric: FilmGenaricList.Action,lanuage: FilmListCategery.English), gridItemListner: this, index: 1),
                            GridItem(film: Film(imgUrl:'https://i.pinimg.com/originals/e2/ed/27/e2ed27aff80b916e5dfb3d360779415b.png',name: "film Name",ratings: 7.8,genaric: FilmGenaricList.Action,lanuage: FilmListCategery.English), gridItemListner: this, index: 2),
                            GridItem(film: Film(imgUrl:'https://www.vantunews.com/storage/app/1578232810-fordvsferrari.jpg',name: "film Name",ratings: 7.8,genaric: FilmGenaricList.Action,lanuage: FilmListCategery.English), gridItemListner: this, index: 3),
                            GridItem(film: Film(imgUrl:'https://media-cache.cinematerial.com/p/500x/qcjprk2e/deadpool-2-movie-poster.jpg?v=1540913690',name: "film Name",ratings: 7.8,genaric: FilmGenaricList.Action,lanuage: FilmListCategery.English), gridItemListner: this, index: 4),
                            GridItem(film: Film(imgUrl:'https://images-na.ssl-images-amazon.com/images/I/61c8%2Bf32PJL._AC_SY679_.jpg',name: "film Name",ratings: 7.8,genaric: FilmGenaricList.Action,lanuage: FilmListCategery.English), gridItemListner: this, index: 5)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ),
            )

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
}