import 'data_interface.dart';
import 'field_messages.dart';

typedef S DataCreator<S>(dynamic json);

class JsonResult<T extends DataInterface> {
  T data;
  List<FieldMessages> fieldMessages;
  List<String> messages;
  String nextHref;
  bool status;

  JsonResult(
      {this.data,
      this.fieldMessages,
      this.messages,
      this.nextHref,
      this.status});

  JsonResult.fromJson(Map<String, dynamic> json, DataCreator<T> dc) {
    if (dc != null) {
      data = json['data'] != null ? dc(json['data']) : null;
    }
    if (json['fieldMessages'] != null) {
      fieldMessages = new List<FieldMessages>();
      json['fieldMessages'].forEach((v) {
        fieldMessages.add(new FieldMessages.fromJson(v));
      });
    }
    messages = json['messages'].cast<String>();
    nextHref = json['nextHref'];
    status = json['status'];
  }
}
