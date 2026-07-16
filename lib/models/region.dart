class Region {
  String? sId;
  String? name;
  double? deliveryFee;

  Region({this.sId, this.name, this.deliveryFee});

  Region.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    deliveryFee = (json['deliveryFee'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['deliveryFee'] = deliveryFee;
    return data;
  }
}
