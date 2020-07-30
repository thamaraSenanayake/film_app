import 'package:film_app/model/film.dart';
import 'package:film_app/module/gridItem/girditemListner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GridItem extends StatefulWidget {
  final Film film;
  final GridItemListner gridItemListner;
  final int index;
  GridItem({Key key, @required this.film,@required this.gridItemListner,@required this.index}) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: 0,
      duration: const Duration(milliseconds: 800),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: Container(
            child: Container(
              child: Image.network(
                widget.film.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}