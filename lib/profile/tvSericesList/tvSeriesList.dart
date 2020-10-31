import 'package:awesome_loader/awesome_loader.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/database/localDb.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/model/tvSerices.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/module/gridItem/gridItem.dart';
import 'package:film_app/profile/filmDetails/filmDetails.dart';
import 'package:film_app/profile/tvSericesList/tvserciesSearch.dart';
import 'package:film_app/profile/tvSeriesDetails/tvSeriesDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../const.dart';
import '../homePage.dart';

class TvSeriesList extends StatefulWidget {
  final HomePageListener listener;
  TvSeriesList({Key key,@required this.listener}) : super(key: key);

  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<TvSeriesList> implements GridItemListner{
  double _height = 0.0;
  double _width = 0.0;
  bool _showSearchText = false;
  final _searchController = TextEditingController();
  bool _loading = true;
  List<Widget> _filmListWidget =[];
  Database database = Database(); 
  List<TvSeries> _tvSeriesList = [];
  FilmListCategery categery;

  _search(){
    FocusScope.of(context).unfocus();
    if(_searchController.text.isNotEmpty){
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => TvSeriesSearch(searchKey:_searchController.text,category:categery,),
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
  void initState() {
    super.initState();
    _loadTvSeries();
  }



  _loadTvSeries() async{
    _tvSeriesList = [];
    List<Widget> _tvSeriesListWidgetTemp =[]; 
    
    _tvSeriesList = await database.allTvSeries();

    for (var item in _tvSeriesList) {
      _tvSeriesListWidgetTemp.add(
        GridItem(film: null,tvSeries: item, gridItemListener: this, index: _tvSeriesList.indexOf(item))
      );
    }

    if(_tvSeriesList.length == AppData.pagesize){
      _tvSeriesListWidgetTemp.add(
        AwesomeLoader(
          loaderType: AwesomeLoader.AwesomeLoader3,
          color: ColorList.Red,
        ),
      );
    }

    setState(() {
      _filmListWidget = _tvSeriesListWidgetTemp;
      _loading = false;
    });

  }

  _loadGeneric() async {
    List<Widget> _tvSerriesWidgetTemp =[]; 
    
    for (var item in _tvSeriesList) {
      if(item.lanuage != categery && categery != null ){
        continue;
      }
      _tvSerriesWidgetTemp.add(
        GridItem(film: null,tvSeries: item, gridItemListener: this, index: _tvSeriesList.indexOf(item))
      );
    }
    setState(() {
      _filmListWidget = _tvSerriesWidgetTemp;
      _loading = false;
    });
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
                            "Tv Serries",
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
                                      categery = null;
                                      _loading = true;
                                    });
                                    _loadTvSeries();
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3)
                                      ),
                                      color: categery == null? ColorList.Red:Colors.white
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "All",
                                          style:TextStyle(
                                            color: categery == null? Colors.white:ColorList.Black,
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
                                      categery = FilmListCategery.English;
                                      _loading = true;
                                    });
                                    _loadGeneric();
                                    
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3)
                                      ),
                                      color: categery == FilmListCategery.English? ColorList.Red:Colors.white
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "English",
                                          style:TextStyle(
                                            color: categery == FilmListCategery.English? Colors.white:ColorList.Black,
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
                                      categery = FilmListCategery.Korean;
                                      _loading = true;
                                    });
                                    _loadGeneric();
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3)
                                      ),
                                      color: categery == FilmListCategery.Korean? ColorList.Red:Colors.white
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Korean",
                                          style:TextStyle(
                                            color: categery == FilmListCategery.Korean? Colors.white:ColorList.Black,
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
                            primary: false,
                            // padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            crossAxisCount: 2,
                            children: _filmListWidget
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
        ),
        opaque: false
      ),
    );
  }

  @override
  gridItemTitleClick(FilmListCategery filmListCategery) {
    
  }

  @override
  gridItemTVSerriesListener(TvSeries tvSeries) {
    DBProvider.db.addRecentlyViewTvSeries(tvSeries); 
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => TvSeriesDetails(
          tvSeries: tvSeries,
        ),
        opaque: false
      ),
    );
  }
}
