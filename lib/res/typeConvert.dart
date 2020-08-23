import '../const.dart';

FilmGenaricList filmGenaricConvert(String filmGenaricList){
  if (FilmGenaricList.Action.toString() == filmGenaricList) {
    return FilmGenaricList.Action;
  } else if (FilmGenaricList.Advenure.toString() == filmGenaricList) {
    return FilmGenaricList.Advenure;
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

FilmListCategery filmListCategeryConvert(String filmListCategery){
  if(FilmListCategery.RecentlyView.toString() == filmListCategery){
    return FilmListCategery.RecentlyView;
  }
  else if(FilmListCategery.NewlyAdd.toString() == filmListCategery){
    return FilmListCategery.NewlyAdd;
  }
  else if(FilmListCategery.English.toString() == filmListCategery){
    return FilmListCategery.English;
  }
  else if(FilmListCategery.Telugu.toString() == filmListCategery){
    return FilmListCategery.Telugu;
  }
  else if(FilmListCategery.Korean.toString() == filmListCategery){
    return FilmListCategery.Korean;
  }
  else if(FilmListCategery.Hindi.toString() == filmListCategery){
    return FilmListCategery.Hindi;
  }
  else if(FilmListCategery.TvSerices.toString() == filmListCategery){
    return FilmListCategery.TvSerices;
  }
  else if(FilmListCategery.Other.toString() == filmListCategery){
    return FilmListCategery.Other;
  }
  else if(FilmListCategery.Tamil.toString() == filmListCategery){
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
  else if(FilmGenaricList.Advenure == filmGenaric){
    genaric ="Advenure";
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
  String lanuage = "";
  if(FilmListCategery.RecentlyView == filmListCategery){
    lanuage = "RecentlyView";
  }
  else if(FilmListCategery.NewlyAdd == filmListCategery){
    lanuage = "NewlyAdd";
  }
  else if(FilmListCategery.English == filmListCategery){
    lanuage = "English";
  }
  else if(FilmListCategery.Telugu == filmListCategery){
    lanuage = "Telugu";
  }
  else if(FilmListCategery.Korean == filmListCategery){
    lanuage = "Korean";
  }
  else if(FilmListCategery.Hindi == filmListCategery){
    lanuage = "Hindi";
  }
  else if(FilmListCategery.TvSerices == filmListCategery){
    lanuage = "TvSerices";
  }
  else if(FilmListCategery.Other == filmListCategery){
    lanuage = "Other";
  }
  else if(FilmListCategery.Tamil == filmListCategery){
    lanuage = "Tamil";
  }
  return lanuage;
}