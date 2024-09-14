class Vitals {
  String id;
  String vitalName;
  double value;
  String user;

  Vitals(this.vitalName, this.value, this.user)
      : id = '';

  Vitals.withId(this.id, this.vitalName, this.value, this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['vitalName'] = vitalName;
    map['value'] = value;
    map['user'] = user;
    return map;
  }

  factory Vitals.fromMap(Map<String, dynamic> map, String id) {
    return Vitals.withId(
      id,
      map['vitalName'],
      map['value'],
      map['user'],  
    );
  }
}
