class SubCategory {
  String? sId;
  String? nameEn;
  String? nameAr;
  String? nameFr;
  CategoryId? categoryId;
  String? createdAt;
  String? updatedAt;

  SubCategory({
    this.sId,
    this.nameEn,
    this.nameAr,
    this.nameFr,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  SubCategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    nameFr = json['nameFr'];
    categoryId = json['categoryId'] != null
        ? CategoryId.fromJson(json['categoryId'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['nameFr'] = nameFr;
    if (categoryId != null) {
      data['categoryId'] = categoryId!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class CategoryId {
  String? sId;
  String? nameEn;
  String? nameAr;
  String? nameFr;

  CategoryId({this.sId, this.nameEn, this.nameAr, this.nameFr});

  CategoryId.fromJson(Map<String, dynamic> json) {
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