import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_app/model/comment.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/res/typeConvert.dart';

import '../const.dart';

class Database{
  
  //collection refreence 
  final CollectionReference filmCollection = Firestore.instance.collection('film');
  final CollectionReference topFilmCollection = Firestore.instance.collection('topFilm');
  final CollectionReference systemData = Firestore.instance.collection('systemData');

  Future<List<Film>> getTopFiveFilms() async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await topFilmCollection
    .orderBy('id',descending:true)
    .getDocuments();

    for (var item in querySnapshot.documents) {
      if(item["comment"].length > 0){
        print(item["name"]);
      }

      
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric:item["genaric"],
        lanuage:item["lanuage"],
        id:item["id"],
        videoUrl: item["videoUrl"]
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> newFilms(int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .orderBy('id',descending:true)
    .limit(limit).getDocuments();

    for (var item in querySnapshot.documents) {
      List<Comment> commentList = [];
      AppData.lastVisible = item;
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> newFilmsNext(int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .orderBy('id',descending:true)
    .limit(limit)
    .startAfterDocument(AppData.lastVisible)
    .getDocuments();

    for (var item in querySnapshot.documents) {
      List<Comment> commentList = [];
      AppData.lastVisible = item;
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> loadByLanguageFilms(FilmListCategery filmListCategery) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .limit(5).getDocuments();

    for (var item in querySnapshot.documents) {
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList:commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<int> getFilmCount() async{
    int filmCount = 0;

    await systemData.document('filmCount').get().then((document){
      filmCount = document['count'];
    });

    return filmCount;

  }

  Future addFilm() async {
    int filmCount = await getFilmCount();
    List<Film> filmList = [];

    for (var item in filmList) {
      
      await filmCollection.document(item.id.toString()).setData({
        "topMovie":item.topMovie,
        "name":item.name,
        "year":item.year,
        "imgUrl":item.imgUrl,
        "ratings":item.ratings,
        "description":item.description,
        "genaric":item.genaric.toString(),
        "lanuage":item.lanuage.toString(),
        "id":item.id,
        "videoUrl":item.videoUrl,
      });

    }

  
  }

  Future<bool> addComment(List<Comment> commentList ,String id) async{
    List<Map<String,dynamic>> commentListMap =[];
    for (var item in commentList) {
      commentListMap.add(
        {
          "name":item.firstName+" "+item.lastName,
          "comment":item.comment,
        }
      );
    }

    filmCollection.document(id).updateData({
      "comment":commentListMap
    });
    return true;
  }

  Future<List<Film>> newMoviesWithGenaric(FilmGenaricList filmGenaricList,int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("genaric",isEqualTo: filmGenaricList.toString())
    .limit(limit).getDocuments();

    for (var item in querySnapshot.documents) {
      AppData.lastVisible = item;
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> newMoviesWithGenaricNext(FilmGenaricList filmGenaricList,int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("genaric",isEqualTo: filmGenaricList.toString())
    .limit(limit)
    .startAfterDocument(AppData.lastVisible)
    .getDocuments();

    for (var item in querySnapshot.documents) {
      AppData.lastVisible = item;
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> allMovies(FilmListCategery filmListCategery,int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .limit(limit).getDocuments();

    for (var item in querySnapshot.documents) {
      AppData.lastVisible = item;
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> allMoviesNext(FilmListCategery filmListCategery,int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .limit(limit)
    .startAfterDocument(AppData.lastVisible).getDocuments();

    for (var item in querySnapshot.documents) {
      AppData.lastVisible = item;
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  Future<List<Film>> moviesWithGenaric(FilmListCategery filmListCategery,FilmGenaricList filmGenaric,int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .where("genaric",isEqualTo: filmGenaric.toString())
    .limit(limit).getDocuments();

    for (var item in querySnapshot.documents) {
      AppData.lastVisible = item;
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }


    return filmList;
  }

  Future<List<Film>> moviesWithGenaricNext(FilmListCategery filmListCategery,FilmGenaricList filmGenaric,int limit) async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .where("genaric",isEqualTo: filmGenaric.toString())
    .limit(limit)
    .startAfterDocument(AppData.lastVisible).getDocuments();

    for (var item in querySnapshot.documents) {
      AppData.lastVisible = item;
      List<Comment> commentList = [];
      if(item["comment"] != null){
        for (var item in item["comment"]) {
          commentList.add(
            Comment(
              comment: item["comment"],
              firstName: item["name"].toString().split(" ")[0],
              lastName: item["name"].toString().split(" ")[1]
            )
          );
        }
      }
      film = Film(
        name:item["name"],
        year:item["year"],
        imgUrl:item["imgUrl"],
        ratings:item["ratings"],
        description:item["description"],
        genaric: filmGenaricConvert(item["genaric"]),
        lanuage:filmListCategeryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }


    return filmList;
  }

  


}