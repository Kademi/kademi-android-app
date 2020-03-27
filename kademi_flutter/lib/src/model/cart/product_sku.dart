class ProductSku {
  int id;
  String name;
  String title;
  String imageHash;

  ProductSku({this.id, this.name, this.title, this.imageHash});

  ProductSku.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    imageHash = json['imageHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['imageHash'] = this.imageHash;
    return data;
  }
}
