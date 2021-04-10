//Model class for a tournament in our app

class Tournament {
  String documentId;
  String name;
  String place;
  String date;
  String scoring;
  String numberOfCourts;
  String typeOfCourts;
  String numberOfPlayers;
  String createdDateAndTime;
  List<Player> playersList;
  String time;

  //Constructor
  Tournament(
      {this.documentId,
      this.name,
      this.place,
      this.date,
      this.scoring,
      this.numberOfCourts,
      this.typeOfCourts,
      this.numberOfPlayers,
      this.createdDateAndTime,
      this.playersList,
      this.time});

  //Create instance from a map
  Tournament.fromJson(Map<String, dynamic> json) {
    this.documentId = json['documentId'];
    this.name = json['name'];
    this.place = json['place'];
    this.date = json['date'];
    this.time=json['time'];
    this.scoring = json['scoring'];
    this.numberOfCourts = json['numberOfCourts'];
    this.numberOfPlayers = json['numberOfPlayers'];
    this.typeOfCourts = json['typeOfCourts'];
    this.createdDateAndTime = json['createdDateAndTime'];
    this.playersList = new List<Player>();
    json['players'].forEach((v) {
      playersList.add(new Player.fromJson(v));
    });
  }

  //Converting object to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['documentId'] = this.documentId;
    json['name'] = this.name;
    json['place'] = this.place;
    json['date'] = this.date;
    json['time']=this.time;
    json['scoring'] = this.scoring;
    json['numberOfCourts'] = this.numberOfCourts;
    json['numberOfPlayers'] = this.numberOfPlayers;
    json['typeOfCourts'] = this.typeOfCourts;
    json['createdDateAndTime'] = this.createdDateAndTime;
    json['players'] = this.playersList.map((e) => e.toJson()).toList();
    return json;
  }
}


//Player class for participants
class Player {
  String name;
  String picture;
  String id;

  Player({this.name, this.picture, this.id});

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    picture = json['picture'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = this.name;
    json['picture'] = this.picture;
    json['id'] = this.id;
    return json;
  }
}
