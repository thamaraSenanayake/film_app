import '../const.dart';

FilmGenaricList filmGenericConvert(String filmGenaricList){
  if (FilmGenaricList.Action.toString() == filmGenaricList) {
    return FilmGenaricList.Action;
  } else if (FilmGenaricList.Adventure.toString() == filmGenaricList) {
    return FilmGenaricList.Adventure;
  }else if (FilmGenaricList.All.toString() == filmGenaricList) {
    return FilmGenaricList.All;
  }else if (FilmGenaricList.Bio.toString() == filmGenaricList) {
    return FilmGenaricList.Bio;
  }else if (FilmGenaricList.Comedy.toString() == filmGenaricList) {
    return FilmGenaricList.Comedy;
  }else if (FilmGenaricList.Crime.toString() == filmGenaricList) {
    return FilmGenaricList.Crime;
  }else if (FilmGenaricList.Drama.toString() == filmGenaricList) {
    return FilmGenaricList.Drama;
  }else if (FilmGenaricList.Family.toString() == filmGenaricList) {
    return FilmGenaricList.Family;
  }else if (FilmGenaricList.Horror.toString() == filmGenaricList) {
    return FilmGenaricList.Horror;
  }else{
    return null;
  }
}

FilmListCategery filmListCategoryConvert(String filmListCategory){
  if(FilmListCategery.RecentlyView.toString() == filmListCategory){
    return FilmListCategery.RecentlyView;
  }
  else if(FilmListCategery.NewlyAdd.toString() == filmListCategory){
    return FilmListCategery.NewlyAdd;
  }
  else if(FilmListCategery.English.toString() == filmListCategory){
    return FilmListCategery.English;
  }
  else if(FilmListCategery.Telugu.toString() == filmListCategory){
    return FilmListCategery.Telugu;
  }
  else if(FilmListCategery.Korean.toString() == filmListCategory){
    return FilmListCategery.Korean;
  }
  else if(FilmListCategery.Hindi.toString() == filmListCategory){
    return FilmListCategery.Hindi;
  }
  else if(FilmListCategery.TvSeries.toString() == filmListCategory){
    return FilmListCategery.TvSeries;
  }
  else if(FilmListCategery.Other.toString() == filmListCategory){
    return FilmListCategery.Other;
  }
  else if(FilmListCategery.Tamil.toString() == filmListCategory){
    return FilmListCategery.Tamil;
  }else{
    return null;
  }

}

String filmGenaricToString(FilmGenaricList filmGenaric){
  String genaric ="";
  if(FilmGenaricList.Action == filmGenaric){
    genaric ="Action";
  }
  else if(FilmGenaricList.Adventure == filmGenaric){
    genaric ="adventure";
  }
  else if(FilmGenaricList.Horror == filmGenaric){
    genaric ="Horror";
  }
  else if(FilmGenaricList.Crime == filmGenaric){
    genaric ="Crime";
  }
  else if(FilmGenaricList.Comedy == filmGenaric){
    genaric ="Comedy";
  }
  else if(FilmGenaricList.Family == filmGenaric){
    genaric ="Family";
  }
  else if(FilmGenaricList.Drama == filmGenaric){
    genaric ="Drama";
  }
  else if(FilmGenaricList.Bio == filmGenaric){
    genaric ="Bio";
  }
  else if(FilmGenaricList.All == filmGenaric){
    genaric ="All";
  }
  return genaric;
}

String filmLanguageToString(FilmListCategery filmListCategery){
  String language = "";
  if(FilmListCategery.RecentlyView == filmListCategery){
    language = "RecentlyView";
  }
  else if(FilmListCategery.NewlyAdd == filmListCategery){
    language = "NewlyAdd";
  }
  else if(FilmListCategery.English == filmListCategery){
    language = "English";
  }
  else if(FilmListCategery.Telugu == filmListCategery){
    language = "Telugu";
  }
  else if(FilmListCategery.Korean == filmListCategery){
    language = "Korean";
  }
  else if(FilmListCategery.Hindi == filmListCategery){
    language = "Hindi";
  }
  else if(FilmListCategery.TvSeries == filmListCategery){
    language = "TvSeries";
  }
  else if(FilmListCategery.Other == filmListCategery){
    language = "Other";
  }
  else if(FilmListCategery.Tamil == filmListCategery){
    language = "Tamil";
  }
  return language;
}