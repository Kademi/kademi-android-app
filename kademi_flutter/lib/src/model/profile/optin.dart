class Optin {
  String name;
  String message;
  bool selected;

  Optin({this.name, this.message, this.selected});

  Optin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['message'] = this.message;
    data['selected'] = this.selected;
    return data;
  }
}
