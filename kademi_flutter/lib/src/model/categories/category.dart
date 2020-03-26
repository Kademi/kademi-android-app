class Category {
  int id;
  String name;
  String title;
  String mainImageHash;
  bool isSelected = false;

  Category({this.id, this.name, this.title, this.mainImageHash});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    mainImageHash = json['mainImageHash'];
  }
}
