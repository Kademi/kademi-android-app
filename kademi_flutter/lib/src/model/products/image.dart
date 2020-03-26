class Image {
  String name;
  String href;
  String hash;

  Image({this.name, this.href, this.hash});

  Image.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    href = json['href'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['href'] = this.href;
    data['hash'] = this.hash;
    return data;
  }
}
