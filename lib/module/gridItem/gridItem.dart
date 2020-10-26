import 'package:film_app/model/film.dart';
import 'package:film_app/model/tvSerices.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:film_app/res/typeConvert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../const.dart';

class GridItem extends StatefulWidget {
  final Film film;
  final TvSeries tvSeries; 
  final GridItemListner gridItemListener;
  final int index;
  GridItem({Key key, @required this.film,@required this.gridItemListener,@required this.index, this.tvSeries}) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  double _width = 0.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _width = MediaQuery.of(context).size.width;
    });
    return AnimationConfiguration.staggeredGrid(
      position: widget.index,
      duration: const Duration(milliseconds: 800),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: (){
              if(widget.film != null){
                widget.gridItemListener.gridItemListner(widget.film);
              }
            },
            child: Container(
              child: Stack(
                children: <Widget>[
                
                  Container(
                    height: _width,
                    width: _width,
                      child: Image.network(
                        widget.film != null? widget.film.imgUrl:widget.tvSeries.imgUrl,
                        fit: BoxFit.cover,
                      ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: _width/8,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.film != null?widget.film.name:widget.tvSeries.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                widget.film != null? Text(
                                  filmGenaricToString(widget.film.genaric),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                  ),
                                ):Container(),
                                RichText(
                                  text: TextSpan(
                                    text:widget.film != null ? widget.film.ratings.toString():widget.tvSeries.ratings.toString()+" / ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
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
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}