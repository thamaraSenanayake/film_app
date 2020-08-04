import 'package:film_app/model/film.dart';
import 'package:flutter/material.dart';

import '../../const.dart';

class RelatedMovieView extends StatefulWidget {
  final Film film;
  RelatedMovieView({Key key, this.film}) : super(key: key);

  @override
  _RelatedMovieViewState createState() => _RelatedMovieViewState();
}

class _RelatedMovieViewState extends State<RelatedMovieView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 150,
        width: 120,
        child: Stack(
          children: <Widget>[
            Container(
              height: 150,
              width: 120,
              child: Image.network(
                widget.film.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                width: 120,
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
                child: Center(
                  child: Text(
                    widget.film.name,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}