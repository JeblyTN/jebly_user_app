import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? discountType;
  String? id;
  String? code;
  String? discount;
  String? image;
  Timestamp? expiresAt;
  String? description;
  bool? isPublic;
  String? resturantId;
  bool? isEnabled;
  String? applyOn;
  bool? applyToAll;
  int? maxUsage;
  int? currentUsage;

  CouponModel({this.discountType, this.id, this.code, this.discount, this.image, this.expiresAt, this.description, this.isPublic, this.resturantId, this.isEnabled, this.applyOn, this.applyToAll, this.maxUsage, this.currentUsage});

  CouponModel.fromJson(Map<String, dynamic> json) {
    discountType = json['discountType'];
    id = json['id'];
    code = json['code'];
    discount = json['discount'];
    image = json['image'];
    expiresAt = json['expiresAt'];
    description = json['description'];
    isPublic = json['isPublic'];
    resturantId = json['resturant_id'];
    isEnabled = json['isEnabled'];
    applyOn = json['applyOn'] ?? 'order';
    applyToAll = json['applyToAll'] ?? false;
    maxUsage = (json['maxUsage'] as num?)?.toInt() ?? 0;
    currentUsage = (json['currentUsage'] as num?)?.toInt() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discountType'] = discountType;
    data['id'] = id;
    data['code'] = code;
    data['discount'] = discount;
    data['image'] = image;
    data['expiresAt'] = expiresAt;
    data['description'] = description;
    data['isPublic'] = isPublic;
    data['resturant_id'] = resturantId;
    data['isEnabled'] = isEnabled;
    data['applyOn'] = applyOn ?? 'order';
    data['applyToAll'] = applyToAll ?? false;
    data['maxUsage'] = maxUsage ?? 0;
    data['currentUsage'] = currentUsage ?? 0;
    return data;
  }
}
