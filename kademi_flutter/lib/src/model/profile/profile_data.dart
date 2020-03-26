import 'package:kademi_app/src/model/json_result/data_interface.dart';

import 'optins.dart';
import 'profile.dart';

class ProfileData extends DataInterface {
  Optins optins;
  Profile profile;

  ProfileData({this.optins, this.profile});

  ProfileData.fromJson(Map<String, dynamic> json) {
    optins =
        json['optins'] != null ? new Optins.fromJson(json['optins']) : null;
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.optins != null) {
      data['optins'] = this.optins.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    return data;
  }
}
