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
    final rawExpiry = json['expiresAt'];
    expiresAt = rawExpiry is Timestamp ? rawExpiry : null;
    description = json['description'];
    isPublic = json['isPublic'];
    resturantId = json['resturant_id'];
    isEnabled = json['isEnabled'];
    applyOn = json['applyOn'] ?? 'order';
    applyToAll = json['applyToAll'] ?? false;
    maxUsage = int.tryParse(json['maxUsage']?.toString() ?? '0') ?? 0;
    currentUsage = int.tryParse(json['currentUsage']?.toString() ?? '0') ?? 0;
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
