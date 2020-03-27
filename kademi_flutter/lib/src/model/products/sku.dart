import 'sku_param.dart';

class Sku {
  String skuTitle;
  List<SkuParam> params;
  String skuCode;
  int skuId;

  Sku({this.skuTitle, this.params, this.skuCode, this.skuId});

  bool matchesParam(Map<String, String> selectedOpts) {
    for (var skuParam in params) {
      if (!selectedOpts.containsKey(skuParam.paramName)) {
        return false;
      } else if (!skuParam.containsOption(selectedOpts[skuParam.paramName])) {
        return false;
      }
    }

    return true;
  }

  Sku.fromJson(Map<String, dynamic> json) {
    skuTitle = json['skuTitle'];
    if (json['params'] != null) {
      params = new List<SkuParam>();
      json['params'].forEach((v) {
        params.add(new SkuParam.fromJson(v));
      });
    }
    skuCode = json['skuCode'];
    skuId = json['skuId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuTitle'] = this.skuTitle;
    if (this.params != null) {
      data['params'] = this.params.map((v) => v.toJson()).toList();
    }
    data['skuCode'] = this.skuCode;
    return data;
  }
}
