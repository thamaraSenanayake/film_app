import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_app/model/comment.dart';
import 'package:film_app/model/film.dart';
import 'package:film_app/profile/filmList.dart/filmList.dart';
import 'package:film_app/res/typeConvert.dart';

import '../const.dart';

class Database{
  
  //collection refreence 
  final CollectionReference filmCollection = Firestore.instance.collection('film');
  final CollectionReference topFilmCollection = Firestore.instance.collection('topFilm');
  final CollectionReference systemData = Firestore.instance.collection('systemData');

  Future<List<Film>> getTopFiveFilms() async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .where('topMovie',isEqualTo: true )
    .getDocuments();

    return setFilmList(querySnapshot);
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
        genaric: filmGenericConvert(item["genaric"]),
        lanuage:filmListCategoryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }

    print("news lendth"+filmList.length.toString());

    return filmList;
  }

  List<Film> setFilmList(QuerySnapshot querySnapshot){
    List<Film> filmList = [];
    Film film;

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
        genaric: filmGenericConvert(item["genaric"]),
        lanuage:filmListCategoryConvert(item["lanuage"]),
        id:item["id"],
        videoUrl: item["videoUrl"],
        filmUrl: item["filmUrl"],
        commentList: commentList
      );
      filmList.add(film);
    }


    return filmList;
  }

  Future<List<Film>> newFilmsNext(int limit) async{
    
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .orderBy('id',descending:true)
    .limit(limit)
    .startAfterDocument(AppData.lastVisible)
    .getDocuments();

    
    return setFilmList(querySnapshot);
  }

  Future<List<Film>> loadByLanguageFilms(FilmListCategery filmListCategery) async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .limit(5).getDocuments();



    return setFilmList(querySnapshot);
  }

  Future<int> getFilmCount() async{
    int filmCount = 0;

    await systemData.document('filmCount').get().then((document){
      filmCount = document['count'];
    });

    return filmCount;

  }

  Future addFilm(Film film) async {
    int filmCount = await getFilmCount();
    String key;
    List<String> searchText = [];
    String searchTextValue ="";

    key=film.name.toLowerCase();

    for (var i = 0; i < key.length; i++) {
      searchTextValue += key[i];
      searchText.add(searchTextValue);
    }
    

    await filmCollection.document((++filmCount).toString()).setData({
      "topMovie":false.toString(),
      "name":film.name,
      "year":film.year,
      "imgUrl":film.imgUrl,
      "ratings":film.ratings,
      "description":film.description,
      "genaric":film.genaric.toString(),
      "lanuage":film.lanuage.toString(),
      "id":filmCount,
      "videoUrl":film.videoUrl,
      "filmUrl":film.filmUrl,
      "search":searchText
    });
    

  
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
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("genaric",isEqualTo: filmGenaricList.toString())
    .limit(limit).getDocuments();


    return setFilmList(querySnapshot);
  }

  Future<List<Film>> newMoviesWithGenaricNext(FilmGenaricList filmGenaricList,int limit) async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("genaric",isEqualTo: filmGenaricList.toString())
    .limit(limit)
    .startAfterDocument(AppData.lastVisible)
    .getDocuments();

    return setFilmList(querySnapshot);
  }

  Future<List<Film>> allMovies(FilmListCategery filmListCategery,int limit) async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .limit(limit).getDocuments();

    return setFilmList(querySnapshot);
  }

  Future<List<Film>> allMoviesNext(FilmListCategery filmListCategery,int limit) async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .limit(limit)
    .startAfterDocument(AppData.lastVisible).getDocuments();

    return setFilmList(querySnapshot);
  }

  Future<List<Film>> moviesWithGenaric(FilmListCategery filmListCategery,FilmGenaricList filmGenaric,int limit) async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .where("genaric",isEqualTo: filmGenaric.toString())
    .limit(limit).getDocuments();

    return setFilmList(querySnapshot);
  }

  Future<List<Film>> moviesWithGenaricNext(FilmListCategery filmListCategery,FilmGenaricList filmGenaric,int limit) async{
    
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection.orderBy('id',descending:true)
    .where("lanuage",isEqualTo: filmListCategery.toString())
    .where("genaric",isEqualTo: filmGenaric.toString())
    .limit(limit)
    .startAfterDocument(AppData.lastVisible).getDocuments();

    return setFilmList(querySnapshot);
  }

  Future<int> getSystemData() async{
    int done = 0;

    await systemData.document('settings').get().then((document){
      AppData.email = document['email'];
      AppData.appIdAndroid = document['appId'];
      AppData.addIdAndroid = document['addId'];
      done = 1;
    });

    return done;

  }

  Future<Film> getMovie(int id) async{
    Film film;
    List<Comment> commentList = [];
    await filmCollection.document(id.toString()).get().then((document){
        
        if(document["comment"] != null){
          for (var item in document["comment"]) {
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
          name:document["name"],
          year:document["year"],
          imgUrl:document["imgUrl"],
          ratings:document["ratings"],
          description:document["description"],
          genaric: filmGenericConvert(document["genaric"]),
          lanuage:filmListCategoryConvert(document["lanuage"]),
          id:document["id"],
          videoUrl: document["videoUrl"],
          commentList: commentList,
          filmUrl: document["filmUrl"],
        );

    });

    return film;
  }


  Future<List<Film>> searchAll(String key) async{
    key=key.toLowerCase();
    
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .where('search',arrayContainsAny: [key])
    .getDocuments();

    return setFilmList(querySnapshot);
  }


  Future<List<Film>> searchLanguage(String key,FilmListCategery category) async{
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .where("lanuage",isEqualTo: category.toString())
    .where('search',arrayContainsAny: [key])
    .getDocuments();

    return setFilmList(querySnapshot);
  }
  


}