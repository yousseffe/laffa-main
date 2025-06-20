class Product {
  String? sId;
  String? nameEn;
  String? nameAr;
  String? nameFr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionFr;
  double? price;
  double? offerPrice;
  ProRef? proCategoryId;
  ProRef? proSubCategoryId;
  List<Images>? images;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Product(
      {this.sId,
        this.nameEn,
        this.nameAr,
        this.nameFr,
        this.descriptionEn,
        this.descriptionAr,
        this.descriptionFr,
        this.price,
        this.offerPrice,
        this.proCategoryId,
        this.proSubCategoryId,
        this.images,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    nameFr = json['nameFr'];
    descriptionEn = json['descriptionEn'];
    descriptionAr = json['descriptionAr'];
    descriptionFr = json['descriptionFr'];
    price = json['price']?.toDouble();
    offerPrice = json['offerPrice']?.toDouble();
    proCategoryId = json['proCategoryId'] != null
        ? ProRef.fromJson(json['proCategoryId'])
        : null;
    proSubCategoryId = json['proSubCategoryId'] != null
        ? ProRef.fromJson(json['proSubCategoryId'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['nameFr'] = nameFr;
    data['descriptionEn'] = descriptionEn;
    data['descriptionAr'] = descriptionAr;
    data['descriptionFr'] = descriptionFr;
    data['price'] = price;
    data['offerPrice'] = offerPrice;
    if (proCategoryId != null) {
      data['proCategoryId'] = proCategoryId!.toJson();
    }
    if (proSubCategoryId != null) {
      data['proSubCategoryId'] = proSubCategoryId!.toJson();
    }
    
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ProRef {
  String? sId;
  String? nameEn;
  String? nameAr;
  String? nameFr;

  ProRef({this.sId, this.nameEn, this.nameAr, this.nameFr});

  ProRef.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    nameFr = json['nameFr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['nameFr'] = nameFr;
    return data;
  }
}

class ProTypeRef {
  String? sId;
  String? type;

  ProTypeRef({this.sId, this.type});

  ProTypeRef.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    return data;
  }
}

class Images {
  int? image;
  String? url;
  String? sId;

  Images({this.image, this.url, this.sId});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    url = json['url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['url'] = url;
    data['_id'] = sId;
    return data;
  }
}