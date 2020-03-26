class FieldMessages {
  String field;
  String message;

  FieldMessages({this.field, this.message});

  FieldMessages.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['message'] = this.message;
    return data;
  }
}
