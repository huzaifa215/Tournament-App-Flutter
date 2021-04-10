//Model class for a user coming from facebook in our app
class UserFacebook {
  String email;
  String name;
  Picture picture;
  String birthday;
  Hometown hometown;
  String id;

  //Constructor
  UserFacebook(
      {this.email,
      this.name,
      this.picture,
      this.birthday,
      this.hometown,
      this.id});

  //Create instance from a map
  UserFacebook.fromFacebook(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    picture =
        json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    birthday = json['birthday'];
    hometown = json['hometown'] != null
        ? new Hometown.fromJson(json['hometown'])
        : null;
    id = json['id'];
  }

  //Converting object to map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    if(this.picture!=null){
      data['picture'] = this.picture.toJson();
    }
    data['birthday'] = this.birthday;
    if(this.hometown!=null){
      data['hometown'] = this.hometown.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Picture {
  Data data;

  Picture({this.data});

  Picture.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int height;
  bool isSilhouette;
  String url;
  int width;

  Data({this.height, this.isSilhouette, this.url, this.width});

  Data.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    isSilhouette = json['is_silhouette'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['is_silhouette'] = this.isSilhouette;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}

class Hometown {
  String id;
  String name;

  Hometown({this.id, this.name});

  Hometown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
