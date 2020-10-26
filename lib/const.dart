import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ColorList{
  static const Black = Color(0xff0f0e0f);
  static const Red = Color(0xffed092c);
  static const Green = Color(0xff2ced09);
}

class KeyContainer {
  static const String HINTDISPLAY = 'hint';
  static const String NOTIFICATION = 'notification';
}

class AppData{
  static DocumentSnapshot lastVisible;
  static const int pagesize =10; 
  static int isDark = 0;
  static String appIdAndroid ="";
  static String appIdIos ="";
  static String email ="";
  static String addIdAndroid ="";
}

enum FilmListCategery{
  RecentlyView,
  NewlyAdd,
  English,
  Telugu,
  Korean,
  Hindi,
  TvSeries,
  Other,
  Tamil
}

enum FilmGenaricList{
  Action,
  Adventure,
  Horror,
  Crime,
  Comedy,
  Family,
  Drama,
  Bio,
  All
}

enum MainType{
  Film,
  TvSeries
}
