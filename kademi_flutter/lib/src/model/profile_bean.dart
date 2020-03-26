import 'json_result/data_interface.dart';

class ProfileBean extends DataInterface {
  String entityName;
  String name;
  String href;
  String userName;
  int userId;
  String photoHash;

  ProfileBean(
      {this.entityName,
      this.name,
      this.href,
      this.userName,
      this.userId,
      this.photoHash});

  ProfileBean.fromJson(Map<String, dynamic> json) {
    entityName = json['entityName'];
    name = json['name'];
    href = json['href'];
    userName = json['userName'];
    userId = json['userId'];
    photoHash = json['photoHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityName'] = this.entityName;
    data['name'] = this.name;
    data['href'] = this.href;
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    data['photoHash'] = this.photoHash;
    return data;
  }
}
