import 'optin.dart';

class Optins {
  Map<String, Optin> optins;

  Optins.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      optins[key] = Optin.fromJson(value);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (optins != null) {
      optins.forEach((key, value) {
        data[key] = value.toJson();
      });
    }

    return data;
  }
}
