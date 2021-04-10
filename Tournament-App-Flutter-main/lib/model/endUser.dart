//Model class for a user in our app

class EndUser {
  String id;
  String name;
  String email;
  String picture;
  String country;
  String birthday;
  String phone;
  dynamic role;

  //Constructor
  EndUser(
      {this.id,
      this.name,
      this.email,
      this.picture,
      this.country,
      this.birthday,
      this.phone,
      this.role});

  //Create instance from a map
  EndUser.fromMap(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.email = json['email'];
    this.picture = json['picture'];
    this.birthday = json['birthday'];
    this.country = json['country'];
    this.phone = json['phone'];
    this.role=json['role'];
  }

  //Converting object to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.name != null) {
      data['name'] = this.name;
    }
    if (this.email != null) {
      data['email'] = this.email;
    }
    if (this.birthday != null) {
      data['birthday'] = this.birthday;
    }
    if (this.picture != null) {
      data['picture'] = this.picture;
    }
    if (this.country != null) {
      data['country'] = this.country;
    }
    if (this.phone != null) {
      data['phone'] = this.phone;
    }
    if (this.role != null) {
      data['role'] = this.role;
    }
    return data;
  }
}
