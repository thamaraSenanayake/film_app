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

  Future<List<Film>> newFilms() async{
    List<Film> filmList = [];
    Film film;
    QuerySnapshot querySnapshot;
    querySnapshot = await filmCollection
    .orderBy('id',descending:true)
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

    filmList.add(
      Film(
        topMovie:false,
        name:"Dolittle",
        year:"2020",
        imgUrl:"https://www.uphe.com/sites/default/files/styles/scale__319w_/public/2020/02/Dolittle_PosterArt.jpg?itok=9fJ5tfOA",
        ratings:5.6,
        description:"After his wife's death, Dr. John Dolittle (Robert Downey, Jr.) decided to hide from the world with his beloved animals. But he has to take a journey to a mysterious island to find a healing tree, which is the only medicine that can help the dying Queen Victoria (Jessie Buckley) in Buckingham Palace.",
        genaric:FilmGenaricList.Advenure,
        lanuage:FilmListCategery.English,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=FEf412bSPLs"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Sonic the Hedgehog",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMDk5Yzc4NzMtODUwOS00NTdhLTg2MjEtZTkzZjc0ZWE2MzAwXkEyXkFqcGdeQXVyMTA3MTA4Mzgw._V1_.jpg",
        ratings:6.6,
        description:"Based on the global blockbuster videogame franchise from Sega, SONIC THE HEDGEHOG tells the story of the world's speediest hedgehog as he embraces his new home on Earth. In this live-action adventure comedy, Sonic and his new best friend Tom (James Marsden) team up to defend the planet from the evil genius Dr. Robotnik (Jim Carrey) and his plans for world domination. The family-friendly film also stars Tika Sumpter and Ben Schwartz as the voice of Sonic. ",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.English,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=szby7ZHLnkA"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Harley Quinn: Birds of Prey",
        year:"2020",
        imgUrl:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSN4GE3wbtK71z9OgQbcTyCMWCqJapuZbcWbA&usqp=CAU",
        ratings:6.1,
        description:"A twisted tale told by Harley Quinn herself, when Gotham's most nefariously narcissistic villain, Roman Sionis, and his zealous right-hand, Zsasz, put a target on a young girl named Cass, the city is turned upside down looking for her. Harley, Huntress, Black Canary and Renee Montoya's paths collide, and the unlikely foursome have no choice but to team up to take Roman down",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.English,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=x3HbbzHK5Mc"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Bad Boys For Life",
        year:"2020",
        imgUrl:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRpcqUWGmWVAHcfJTmUJBfzyzrF4lUv6UhXFA&usqp=CAU",
        ratings:6.6,
        description:"Marcus and Mike have to confront new issues (career changes and midlife crises), as they join the newly created elite team AMMO of the Miami police department to take down the ruthless Armando Armas, the vicious leader of a Miami drug cartel.",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.English,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=jKCj3XuPG8M"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Bloodshot",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BYjA5YjA2YjUtMGRlNi00ZTU4LThhZmMtNDc0OTg4ZWExZjI3XkEyXkFqcGdeQXVyNjUyNjI3NzU@._V1_SY1000_SX800_AL_.jpg",
        ratings:5.7,
        description:"Ray Garrison, an elite soldier who was killed in battle, is brought back to life by an advanced technology that gives him the ability of super human strength and fast healing. With his new abilities, he goes after the man who killed his wife, or at least, who he believes killed his wife. He soon comes to learn that not everything he learns can be trusted. The true question is: Can he even trust himself?",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.English,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=vOUVVDWdXbo"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"War",
        year:"2019",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BNTlmNDMzOWQtYzg4Ny00OWQ0LWFhN2MtNmQ2MDczZGZhNTU5XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SY1000_CR0,0,730,1000_AL_.jpg",
        ratings:6.5,
        description:"India's top agent Kabir (Hrithik Roshan) leads the Elite Shadow Unit of R&AW, a compact group of the crème de la crème of the armed forces who are personally trained by him and work with him on various high-risk missions across the world. Among Kabir and Colonel Luthra's key targets are an international arms baron Rizwan Ilyasi who has been key in various acts of terrorism against the country. Khalid (Tiger Shroff) has fought his way up the ranks of the Indian armed forces. His greatest challenge and battle has been to fight against the sins of his father, once a decorated soldier working with Kabir who had turned a traitor. His ambition has been to join Kabir's team to remove any stains on their family name. Kabir is not keen due to their past history, but Colonel Luthra requests him to, and gradually Kabir is also impressed by Khalid's intense dedication and grit. Khalid becomes Kabir's greatest soldier ever, flirting with death repeatedly in mission after mission as they go after ...",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.Hindi,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=tQ0mzXRk-oM"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Angrezi Medium",
        year:"2019",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BNjlkZjBjZmUtNjZjNS00ODlkLWIzODYtODY0NmViN2E0MjIxXkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SY1000_CR0,0,692,1000_AL_.jpg",
        ratings:7.3,
        description:"When his daughter decides to further her studies in London, a hardworking Rajasthani businessman does everything in power to make her dreams come true.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Hindi,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=tQ0mzXRk-oM"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Dil Bechara",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BNmI0MTliMTAtMmJhNC00NTJmLTllMzQtMDI3NzA1ODMyZWI1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SY1000_CR0,0,800,1000_AL_.jpg",
        ratings:8.9,
        description:"Based on the bestselling novel \"The Fault in Our Stars\" by author John Green, Dil Bechara is a story of Kizie and Manny, two ordinary people with an extraordinary love story. Both have a tragic twist to their lives. That was the start of exploring a funny, thrilling and tragic business of being alive and in love. Kizie and Manny embark on an, on and off, up and down, bitter and sweet profound journey into the heart of that crazy little thing called 'life'.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Hindi,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=GODAlxW5Pes"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Tanhaji",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMDc5ZmQ3MzUtYTY4OS00YTE3LTkwNmItNmQ2ODIwNWM3MzY1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SY1000_SX750_AL_.jpg",
        ratings:7.6,
        description:"Tanhaji is an action epic about the titular Maratha warrior and Shivaji's military commander who lost his father in a battle and grew up to become a fierce warrior with powerful combat skills. When Mughal emperor Aurangzeb recruits his trusted guard Udaybhan to take control of the Kondhana Fort, Shivaji decides not to engage Tanhaji whose son is going to get married soon. However, as Tanhaji learns of Udaybhan's heading towards the fortress, he decides to take charge and stop the rival army from reaching their destination. This doesn't turn out to be easy as Udaybhan finds himself helped by people who don't want Tanhaji to succeed, resulting in battles and attacks that ensue as the plot unfolds.",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.Hindi,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=cffAGIYTEHU"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Gulabo Sitabo",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BN2E2NGQzNzQtNTVhMS00NjdhLTk3MzgtNDFkOTg2YTg1MmFkXkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SY1000_CR0,0,692,1000_AL_.jpg",
        ratings:6.4,
        description:"Welcome to the world of Gulabo Sitabo where two slimy scheming foxes in a game of one-upmanship, each one attracting other members to their clan and each one with an agenda of his own. Meet 'Mirza' (Amitabh Bachchan) - a 78yrs old landlord, who would move heaven and earth for his most prized possession - an old dilapidated mansion in the heart of Lucknow. But this garden of roses comes with its own cluster of 'pricky thorns' - tenants. Amongst them most prominently, 'Baankey' (Ayushmann Khuranna)' a shrewd, sly and squatted tenant, who matches Mirza bit for a bit in their ceaseless bantering. Gulabo Sitabo is a quirky slice of life where Mirza and Baankey are like Tom and Jerry - unique and unmatched, friend and foe, naughty and smart, little and large, all combine to produce chaos.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Hindi,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=o0qeQ_yHqtA"
      )
    );

    

    filmList.add(
      Film(
        topMovie:false,
        name:"Ponmagal Vandhal",
        year:"2019",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BNTk2OTcyNzgtMDA5ZC00YjMwLWIxNzMtNDU2Y2U1NzU4ZTMwXkEyXkFqcGdeQXVyODQ5NDUwMDk@._V1_.jpg",
        ratings:6.9,
        description:"Ponmagal Vandhal, is a Murder Mystery Courtroom Drama set in Ooty, 2020. Venba (Jyotika), a determined lawyer, reopens the case of a serial killer Jothi, after 15 Years. This is Venba's journey against child abuse and her quest for justice.",
        genaric:FilmGenaricList.Drama,
        lanuage:FilmListCategery.Tamil,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=vzfe8UEJFd0"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Bigil",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BYTIyNWM5YzgtZDhkNC00MmZjLWIxODItYTViZmVmZjlkMDE3XkEyXkFqcGdeQXVyOTk3NTc2MzE@._V1_SY1000_SX640_AL_.jpg",
        ratings:6.8,
        description:"This movie revolves around on how a football player sacrifices his dream for his father, who is a gangster and who also wants his son to achieve big in football. Later, he gets a second chance to achieve his dream where he needs to coach a women's football team to glory with many obstacles.",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.Tamil,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=IiUNRYQ1Cak"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Robot 2",
        year:"2018",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BOGNhMWE2YzktYzU0Yi00OGFlLTlhYzMtODBiOGFiZTM1YjI1XkEyXkFqcGdeQXVyODIwMDI1NjM@._V1_.jpg",
        ratings:6.3,
        description:"8 years after Chitti was dismantled due to destruction he caused. Vaseegaran has created new human robot Nila which can understand human feelings better. The cell phones in the city start to disappear from everywhere. A creature in the form of bird creates havoc in the city causing destruction. Vaseegaran believes it to be the fifth element force and decides to get Chitti back in action. When Vaseegaran traces the location of missing cellphones with help of Chitti and Nila he finds that its not the fifth force but a human force done by late professor Pakshi Rajan.",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.Tamil,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=_qOl_7qfPOM"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Dharala Prabhu",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BOTM4ZmYyNWUtYzU4MS00ODBiLWI4ZTctODgzNzhhZjg2YmFiXkEyXkFqcGdeQXVyMzYxOTQ3MDg@._V1_SY1000_CR0,0,639,1000_AL_.jpg",
        ratings:6.8,
        description:"When Prabhu is approached by a doctor from a fertility clinic, he agrees to donate his sperm to make some money. While his sperm is highly successful, his own life gets twisted around because of it.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Tamil,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=3ZKf8yMfTGM"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Asuran",
        year:"2019",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMTQ3YWY1MzQtNDA3OC00MDY1LTk3ZmMtMzNjZmFjY2FhYWNhXkEyXkFqcGdeQXVyODIwMDI1NjM@._V1_SY1000_CR0,0,706,1000_AL_.jpg",
        ratings:8.5,
        description:"Asuran is an action film directed by Vetrimaaran, with the story taken from the novel Vekkai written by Poomani, a famous Tamil novelist. Dhanush plays two roles in this film. Famous Malayalam actress Manju Warrier plays the female lead. Many people expecting this movie will be the benchmark for Tamil cinema in both critically and commercially. Trailer of this film was released on Dhanush's birthday and the film was released on 3 October 2019",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.Tamil,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=vOCM9wztBYQ"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Dharala Prabhu",
        year:"2020",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BOTM4ZmYyNWUtYzU4MS00ODBiLWI4ZTctODgzNzhhZjg2YmFiXkEyXkFqcGdeQXVyMzYxOTQ3MDg@._V1_SY1000_CR0,0,639,1000_AL_.jpg",
        ratings:6.8,
        description:"When Prabhu is approached by a doctor from a fertility clinic, he agrees to donate his sperm to make some money. While his sperm is highly successful, his own life gets twisted around because of it.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Tamil,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=_qOl_7qfPOM"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Parasite",
        year:"2019",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BYWZjMjk3ZTItODQ2ZC00NTY5LWE0ZDYtZTI3MjcwN2Q5NTVkXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_SY1000_CR0,0,674,1000_AL_.jpg",
        ratings:8.6,
        description:"The Kims - mother and father Chung-sook and Ki-taek, and their young adult offspring, son Ki-woo and daughter Ki-jung - are a poor family living in a shabby and cramped half basement apartment in a busy lower working class commercial district of Seoul. Without even knowing it, they, especially Mr. and Mrs. Kim, literally smell of poverty. Often as a collective, they perpetrate minor scams to get by, and even when they have jobs, they do the minimum work required. Ki-woo is the one who has dreams of getting out of poverty by one day going to university. Despite not having that university education, Ki-woo is chosen by his university student friend Min, who is leaving to go to school, to take over his tutoring job to Park Da-hye, who Min plans to date once he returns to Seoul and she herself is in university. The Parks are a wealthy family who for four years have lived in their modernistic house designed by and the former residence of famed architect Namgoong.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Korean,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=isOGD_7hNIY"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Train to Busan",
        year:"2016",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMTkwOTQ4OTg0OV5BMl5BanBnXkFtZTgwMzQyOTM0OTE@._V1_.jpg",
        ratings:7.6,
        description:"Sok-woo, a father with not much time for his daughter, Soo-ahn, are boarding the KTX, a fast train that shall bring them from Seoul to Busan. But during their journey, the apocalypse begins, and most of the earth's population become flesh craving zombies. While the KTX is shooting towards Busan, the passenger's fight for their families and lives against the zombies - and each other.",
        genaric:FilmGenaricList.Action,
        lanuage:FilmListCategery.Korean,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=1ovgxN2VWNc"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Burning",
        year:"2018",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMWNmYjI1M2UtNDdkNi00MTgwLWFiZmYtODcxNWZhM2Y2NWFkXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SY1000_CR0,0,700,1000_AL_.jpg",
        ratings:7.5,
        description:"Jong-su bumps into a girl who used to live in the same neighborhood, who asks him to look after her cat while she's on a trip to Africa. When back, she introduces Ben, a mysterious guy she met there, who confesses his secret hobby.",
        genaric:FilmGenaricList.Drama,
        lanuage:FilmListCategery.Korean,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=oihHs2Errwk"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Extreme Job",
        year:"2019",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMWNmYjI1M2UtNDdkNi00MTgwLWFiZmYtODcxNWZhM2Y2NWFkXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SY1000_CR0,0,700,1000_AL_.jpg",
        ratings:7.5,
        description:"Jong-su bumps into a girl who used to live in the same neighborhood, who asks him to look after her cat while she's on a trip to Africa. When back, she introduces Ben, a mysterious guy she met there, who confesses his secret hobby.",
        genaric:FilmGenaricList.Drama,
        lanuage:FilmListCategery.Korean,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=oihHs2Errwk"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"Burning",
        year:"2018",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BMWE2ZmI5NjEtMzQ5Zi00Zjk4LWFiODItOTRkNjMwYTY1YWNlXkEyXkFqcGdeQXVyNzI1NzMxNzM@._V1_SY1000_CR0,0,701,1000_AL_.jpg",
        ratings:7.0,
        description:"A team of narcotics detectives goes undercover in a fried chicken joint to stake out an organized crime gang. But things take an unexpected turn when the detectives' chicken recipe suddenly transforms the rundown restaurant into the hottest eatery in town.",
        genaric:FilmGenaricList.Comedy,
        lanuage:FilmListCategery.Korean,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=l9Hu3Xocc-g"
      )
    );

    filmList.add(
      Film(
        topMovie:false,
        name:"The Handmaiden",
        year:"2016",
        imgUrl:"https://m.media-amazon.com/images/M/MV5BNDJhYTk2MTctZmVmOS00OTViLTgxNjQtMzQxOTRiMDdmNGRjXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SY1000_CR0,0,695,1000_AL_.jpg",
        ratings:8.1,
        description:"1930s Korea, in the period of Japanese occupation, a new girl (Sookee) is hired as a handmaiden to a Japanese heiress (Hideko) who lives a secluded life on a large countryside estate with her domineering Uncle (Kouzuki). But the maid has a secret. She is a pickpocket recruited by a swindler posing as a Japanese Count to help him seduce the Lady to elope with him, rob her of her fortune, and lock her up in a madhouse. The plan seems to proceed according to plan until Sookee and Hideko discover some unexpected emotions.",
        genaric:FilmGenaricList.Drama,
        lanuage:FilmListCategery.Korean,
        id:filmCount++,
        videoUrl: "https://www.youtube.com/watch?v=whldChqCsYk"
      )
    );

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

  Future<List<Film>> allMovies(FilmListCategery filmListCategery,FilmGenaricList filmGenaric,int limit) async{
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
    .startAfter(AppData.lastVisible).getDocuments();

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
    .startAfter(AppData.lastVisible).getDocuments();

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