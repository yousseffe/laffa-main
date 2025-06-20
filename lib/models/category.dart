class Category {
  String? sId;
  String? nameEn;
  String? nameAr;
  String? nameFr;
  bool isSelected;
  String? createdAt;
  String? updatedAt;

  Category({
    this.sId,
    this.nameEn,
    this.nameAr,
    this.nameFr,
    this.isSelected = false,
    this.createdAt,
    this.updatedAt,
  });

  Category.fromJson(Map<String, dynamic> json)
      : sId = json['_id'],
        nameEn = json['nameEn'],
        nameAr = json['nameAr'],
        nameFr = json['nameFr'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        isSelected = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    print(data);
    
    data['_id'] = sId;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['nameFr'] = nameFr;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
