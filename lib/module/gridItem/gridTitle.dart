import 'package:film_app/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'girditemListner.dart';

class GridHeader extends StatefulWidget {
  final String title;
  final int index;
  final GridItemListner gridItemListner;
  final FilmListCategery filmListCategery;
  GridHeader({Key key,@required this.title, this.index,@required this.gridItemListner,@required this.filmListCategery}) : super(key: key);

  @override
  _GridHeaderState createState() => _GridHeaderState();
}

class _GridHeaderState extends State<GridHeader> {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: 0,
      duration: const Duration(milliseconds: 800),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    // width: 110,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                      ),
                    ),
                    
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: (){
                      widget.gridItemListner.gridItemListner(widget.gridItemListner.gridItemTitleClick(widget.filmListCategery));
                    },
                    child: Container(
                      // width: 110,
                      child: Text(
                        "See All",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      
                    ),
                  ),
                )
              ],
            ),
            // color: Colors.teal[100],
          ),
        ),
      ),
    );
  }
}