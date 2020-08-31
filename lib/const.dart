import 'package:flutter/material.dart';

class ColorList{
  static const Black = Color(0xff0f0e0f);
  static const Red = Color(0xffed092c);
  static const Green = Color(0xff2ced09);
}

class KeyContainer {
  static const String HINTDISPLAY = 'hint';
}

class AppData{
  static var lastVisible;
}

enum FilmListCategery{
  RecentlyView,
  NewlyAdd,
  English,
  Telugu,
  Korean,
  Hindi,
  TvSerices,
  Other,
  Tamil
}

enum FilmGenaricList{
  Action,
  Advenure,
  Horror,
  Crime,
  Comedy,
  Family,
  Drama,
  Bio,
  All
}