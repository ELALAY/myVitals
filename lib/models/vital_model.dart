class VitalsModel {
  String id;
  String vitalCategory;
  double value;
  String user;
  DateTime date;

  VitalsModel(this.vitalCategory, this.value, this.user, this.date)
      : id = '';

  VitalsModel.withId(this.id, this.vitalCategory, this.value, this.user, this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['vitalName'] = vitalCategory;
    map['value'] = value;
    map['user'] = user;
    map['date'] = date;
    return map;
  }

  factory VitalsModel.fromMap(Map<String, dynamic> map, String id) {
    return VitalsModel.withId(
      id,
      map['vitalName'],
      map['value'],
      map['user'],
      map['date'],
    );
  }
}
