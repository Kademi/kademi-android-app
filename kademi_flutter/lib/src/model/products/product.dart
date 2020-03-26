import 'image.dart';
import 'sku.dart';

class Product {
  String brief;
  int product;
  List<Image> images;
  List<Sku> skus;
  double finalCost;
  String title;
  int storeId;
  String content;
  String sortableTitle;
  List<String> tags;
  int variantCount;
  String path;
  List<int> categoryIds;
  String productCode;
  String createdDate;
  int primaryImageId;
  List<String> attributeNames;
  String webName;
  String name;
  int position;
  int productInStore;
  double productRrp;
  String primaryImageHref;
  Product(
      {this.brief,
      this.product,
      this.images,
      this.skus,
      this.finalCost,
      this.title,
      this.storeId,
      this.content,
      this.sortableTitle,
      this.tags,
      this.variantCount,
      this.path,
      this.categoryIds,
      this.productCode,
      this.createdDate,
      this.primaryImageId,
      this.attributeNames,
      this.webName,
      this.name,
      this.position,
      this.productInStore,
      this.productRrp,
      this.primaryImageHref});

  Product.fromJson(Map<String, dynamic> json) {
    brief = json['brief'];
    product = json['product'];
    if (json['images'] != null) {
      images = new List<Image>();
      json['images'].forEach((v) {
        images.add(new Image.fromJson(v));
      });
    }
    if (json['skus'] != null) {
      skus = new List<Sku>();
      json['skus'].forEach((v) {
        skus.add(new Sku.fromJson(v));
      });
    }
    finalCost = json['finalCost'].toDouble();
    title = json['title'];
    storeId = json['storeId'];
    content = json['content'];
    sortableTitle = json['sortableTitle'];
    tags = json['tags'].cast<String>();
    variantCount = json['variantCount'];
    path = json['path'];
    categoryIds = json['categoryIds'].cast<int>();
    productCode = json['productCode'];
    createdDate = json['createdDate'];
    primaryImageId = json['primaryImageId'];
    attributeNames = json['attributeNames'].cast<String>();
    webName = json['webName'];
    name = json['name'];
    position = json['position'];
    productInStore = json['productInStore'];
    productRrp = json['productRrp'];
    primaryImageHref = json['primaryImageHref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brief'] = this.brief;
    data['product'] = this.product;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.skus != null) {
      data['skus'] = this.skus.map((v) => v.toJson()).toList();
    }
    data['finalCost'] = this.finalCost;
    data['title'] = this.title;
    data['storeId'] = this.storeId;
    data['content'] = this.content;
    data['sortableTitle'] = this.sortableTitle;
    data['tags'] = this.tags;
    data['variantCount'] = this.variantCount;
    data['path'] = this.path;
    data['categoryIds'] = this.categoryIds;
    data['productCode'] = this.productCode;
    data['createdDate'] = this.createdDate;
    data['primaryImageId'] = this.primaryImageId;
    data['attributeNames'] = this.attributeNames;
    data['webName'] = this.webName;
    data['name'] = this.name;
    data['position'] = this.position;
    data['productInStore'] = this.productInStore;
    data['productRrp'] = this.productRrp;
    data['primaryImageHref'] = this.primaryImageHref;
    return data;
  }
}
