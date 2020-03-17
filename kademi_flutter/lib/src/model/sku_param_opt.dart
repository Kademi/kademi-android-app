class SkuParamOpts {
  String optName;
  String optTitle;

  SkuParamOpts({this.optName, this.optTitle});

  SkuParamOpts.fromJson(Map<String, dynamic> json) {
    optName = json['optName'];
    optTitle = json['optTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optName'] = this.optName;
    data['optTitle'] = this.optTitle;
    return data;
  }
}
