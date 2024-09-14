class VitalsModel {
  String id;
  String vitalCategory;
  double value;
  String user;

  VitalsModel(this.vitalCategory, this.value, this.user)
      : id = '';

  VitalsModel.withId(this.id, this.vitalCategory, this.value, this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['vitalName'] = vitalCategory;
    map['value'] = value;
    map['user'] = user;
    return map;
  }

  factory VitalsModel.fromMap(Map<String, dynamic> map, String id) {
    return VitalsModel.withId(
      id,
      map['vitalName'],
      map['value'],
      map['user'],
    );
  }
}
