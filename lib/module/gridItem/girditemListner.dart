import 'package:film_app/const.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/model/tvSerices.dart';

abstract class GridItemListner{
  gridItemListner(Film film);
  gridItemTVSerriesListener(TvSeries tvSeries);
  gridItemTitleClick(FilmListCategery filmListCategery);
}