import 'dart:io';
import 'package:film_app/model/film.dart';
import 'package:film_app/res/typeConvert.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  //check database avalablity
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      //if _database is null, instantiate it
      _database = await initDB();
      return _database;
    }
  }

  databaseAvailability() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "filmApp.db");
    bool availability = await databaseFactory.databaseExists(path);

    return availability;
  }

  //create the database in app Directory
  initDB() async {
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "filmApp.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Film ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT NOT NULL,"
          "year TEXT NOT NULL,"
          "imgUrl TEXT NOT NULL,"
          "ratings TEXT NOT NULL,"
          "description TEXT NOT NULL,"
          "genaric TEXT NOT NULL,"
          "lanuage TEXT NOT NULL,"
          "videoUrl TEXT NOT NULL,"
          "timeStampRecently INTEGER,"
          "timeStampFavorite INTEGER,"
          "recentFilm INTEGER,"
          "likedFilm INTEGER"
          ")");
    });
  }

  likeUnLikeFilm(Film film,int likeUnLike) async {
    final db = await database;
    var res = 'done';

    

    try {
      await db.execute("UPDATE `Film` SET `likedFilm`=1, `timeStampFavorite` = "+DateTime.now().millisecondsSinceEpoch.toString()+" WHERE `id` = "+film.id.toString());
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  addRecentlyViewFilm(Film film) async {
    final db = await database;
    var res = 'done';
    int count = 0; 

    try {
      var res = await db.rawQuery("Select * from Film where id=" +film.id.toString());
      count = res.length;
      
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }

    try {
      if(count == 0){
        await db.execute(
          "INSERT INTO `Film`( `id`,`name`,`year`,`imgUrl`,`ratings`,`description`,`genaric`,`lanuage`,`videoUrl`,`timeStampRecently`,`recentFilm`,`likedFilm`) VALUES (" +
              film.id.toString()+
              ",'" +
              film.name+
              "','" +
              film.year+
              "','" +
              film.imgUrl+
              "','" +
              film.ratings.toString()+
              "','" +
              film.description.replaceAll('\'', "")+
              "','" +
              film.genaric.toString()+
              "','" +
              film.lanuage.toString()+
              "','" +
              film.videoUrl+
              "'," +
              DateTime.now().millisecondsSinceEpoch.toString()+
              "," +
              "1,"+
              "0"+
              ")"
        );
      }else{
        await db.execute("UPDATE `Film` SET `recentFilm`=1, `timeStampRecently` = "+DateTime.now().millisecondsSinceEpoch.toString()+" WHERE `id` = "+film.id.toString());
      }
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  deleteHistory() async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("UPDATE `Film` SET `recentFilm`=0 ");
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }


  isLiked(Film film) async {
    final db = await database;
    var res = 'done';
    int count = 0; 

    try {
      var res = await db.rawQuery("Select * from Film where id=" +film.id.toString()+" and likedFilm =1");
      count = res.length;
      
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }

    if(count == 1 ){
      return true;
    }else{
      return false;
    }

  }

  Future<List<Film>> recentFilmList() async {
    List<Film> filmList = [];
    final db = await database;

    try {
      var res = await db.rawQuery("Select * from film where recentFilm= 1 order by timeStampRecently desc");
      for (var item in res) {
        filmList.add(
          Film(
            id: item["id"],
            name: item["name"],
            year: item["year"],
            imgUrl: item["imgUrl"],
            ratings: double.parse(item["ratings"]),
            description: item["description"],
            genaric: filmGenericConvert( item["genaric"]),
            lanuage: filmListCategoryConvert(item["lanuage"]),
            videoUrl: item["videoUrl"],
          )
        );
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return filmList;
  }

  Future<List<Film>> favoriteFilmList() async {
    List<Film> filmList = [];
    final db = await database;

    try {
      var res = await db.rawQuery("Select * from film where likedFilm= 1 order by timeStampFavorite desc");
      for (var item in res) {
        filmList.add(
          Film(
            id: item["id"],
            name: item["name"],
            year: item["year"],
            imgUrl: item["imgUrl"],
            ratings: double.parse(item["ratings"]),
            description: item["description"],
            genaric: filmGenericConvert( item["genaric"]),
            lanuage: filmListCategoryConvert(item["lanuage"]),
            videoUrl: item["videoUrl"],
          )
        );
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return filmList;
  }


}