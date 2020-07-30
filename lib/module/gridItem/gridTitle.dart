import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GridHeader extends StatefulWidget {
  final String title;
  final int index;
  GridHeader({Key key,@required this.title, this.index}) : super(key: key);

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
            child: Center(
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
            // color: Colors.teal[100],
          ),
        ),
      ),
    );
  }
}