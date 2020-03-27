import 'sku_param_opt.dart';

class SkuParam {
  List<SkuParamOpts> opts;
  String paramTitle;
  String paramName;

  SkuParam({this.opts, this.paramTitle, this.paramName});

  bool containsOption(String optName) {
    if (opts != null && opts.isNotEmpty) {
      for (var opt in opts) {
        if (opt.optName == optName) {
          return true;
        }
      }
    }
    return false;
  }

  SkuParam.fromJson(Map<String, dynamic> json) {
    if (json['opts'] != null) {
      opts = new List<SkuParamOpts>();
      json['opts'].forEach((v) {
        opts.add(new SkuParamOpts.fromJson(v));
      });
    }
    paramTitle = json['paramTitle'];
    paramName = json['paramName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.opts != null) {
      data['opts'] = this.opts.map((v) => v.toJson()).toList();
    }
    data['paramTitle'] = this.paramTitle;
    data['paramName'] = this.paramName;
    return data;
  }
}
