import 'package:film_app/model/comment.dart';

import '../const.dart';

class Film{
  final String name;
  final String year;
  final String imgUrl;
  final double ratings;
  final String description;
  final FilmGenaricList genaric;
  final FilmListCategery lanuage;
  final int id;
  final String videoUrl;
  final bool topMovie;
  final List<Comment> commentList;

  Film({this.commentList, this.topMovie, this.videoUrl,this.id,this.name, this.year, this.imgUrl, this.ratings, this.description, this.genaric, this.lanuage});
}