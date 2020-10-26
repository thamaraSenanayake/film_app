import 'package:awesome_loader/awesome_loader.dart';
import 'package:film_app/database/databse.dart';
import 'package:film_app/database/localDb.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/model/tvSerices.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/module/gridItem/gridItem.dart';
import 'package:film_app/profile/filmDetails/filmDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../const.dart';

class TvSeriesFavorite extends StatefulWidget {
  TvSeriesFavorite({Key key}) : super(key: key);

  @override
  _TvSeriesFavoriteState createState() => _TvSeriesFavoriteState();
}

class _TvSeriesFavoriteState extends State<TvSeriesFavorite> implements GridItemListner{
  double _height = 0.0;
  double _width = 0.0;
  bool _loading = true;
  List<Widget> _tvSeriesWidget =[];
  List<TvSeries> _tvSeries = [];


  @override
  void initState() {
    super.initState();
    _loadFilms();
  }

  _loadFilms() async{
    _tvSeries = [];
    List<Widget> _tvSeriesWidgetTemp =[]; 
    
    _tvSeries = await DBProvider.db.favoriteTvSerriesList(MainType.Film);

    for (var item in _tvSeries) {
      _tvSeriesWidgetTemp.add(
        GridItem(film: null,tvSeries: item, gridItemListener: this, index: _tvSeries.indexOf(item))
      );
    }
    
    setState(() {
      _tvSeriesWidget = _tvSeriesWidgetTemp;
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
                    padding: const EdgeInsets.only(bottom:10.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Text(
                          "Favorite TV Series",
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
                          children: _tvSeriesWidget
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
    
  }
}
