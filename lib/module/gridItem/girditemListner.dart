import 'package:film_app/const.dart';
import 'package:film_app/model/film.dart';

abstract class GridItemListner{
  gridItemListner(Film film);
  gridItemTitleClick(FilmListCategery filmListCategery);
}