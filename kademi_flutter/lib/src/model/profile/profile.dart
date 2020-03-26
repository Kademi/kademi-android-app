class Profile {
  DateTime lastContacted;
  String notes;
  String surName;
  String nickName;
  DateTime lastVisit;
  String language;
  String userName;
  DateTime birthDate;
  int userId;
  String photoHash;
  String firstName;
  String phone;
  String entityName;
  String name;
  String href;
  String email;

  Profile(
      {this.lastContacted,
      this.notes,
      this.surName,
      this.nickName,
      this.lastVisit,
      this.language,
      this.userName,
      this.birthDate,
      this.userId,
      this.photoHash,
      this.firstName,
      this.phone,
      this.entityName,
      this.name,
      this.href,
      this.email});

  Profile.fromJson(Map<String, dynamic> json) {
    lastContacted = json['lastContacted'] != null &&
            json['lastContacted']['time'] != null
        ? new DateTime.fromMillisecondsSinceEpoch(json['lastContacted']['time'])
        : null;

    lastVisit = json['lastVisit'] != null && json['lastVisit']['time'] != null
        ? new DateTime.fromMillisecondsSinceEpoch(json['lastVisit']['time'])
        : null;

    birthDate = json['birthDate'] != null && json['birthDate']['time'] != null
        ? new DateTime.fromMillisecondsSinceEpoch(json['birthDate']['time'])
        : null;

    notes = json['notes'];
    surName = json['surName'];
    nickName = json['nickName'];
    language = json['language'];
    userName = json['userName'];
    userId = json['userId'];
    photoHash = json['photoHash'];
    firstName = json['firstName'];
    phone = json['phone'];
    entityName = json['entityName'];
    name = json['name'];
    href = json['href'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastContacted != null) {
      data['lastContacted'] = this.lastContacted.millisecondsSinceEpoch;
    }
    data['notes'] = this.notes;
    data['surName'] = this.surName;
    data['nickName'] = this.nickName;
    if (this.lastVisit != null) {
      data['lastVisit'] = this.lastVisit.millisecondsSinceEpoch;
    }
    data['language'] = this.language;
    data['userName'] = this.userName;
    data['birthDate'] = this.birthDate;
    data['userId'] = this.userId;
    data['photoHash'] = this.photoHash;
    data['firstName'] = this.firstName;
    data['phone'] = this.phone;
    data['entityName'] = this.entityName;
    data['name'] = this.name;
    data['href'] = this.href;
    data['email'] = this.email;
    return data;
  }
}
