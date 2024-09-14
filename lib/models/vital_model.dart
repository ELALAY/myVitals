class Vitals {
  String id;
  String vitalCategory;
  double value;
  String user;
  double maxCriticalValue;
  double minCriticalValue;

  Vitals(this.vitalCategory, this.value, this.user, this.maxCriticalValue,
      this.minCriticalValue)
      : id = '';

  Vitals.withId(this.id, this.vitalCategory, this.value, this.user,
      this.maxCriticalValue, this.minCriticalValue);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['vitalName'] = vitalCategory;
    map['value'] = value;
    map['user'] = user;
    map['maxCriticalValue'] = maxCriticalValue;
    map['minCriticalValue'] = minCriticalValue;
    return map;
  }

  factory Vitals.fromMap(Map<String, dynamic> map, String id) {
    return Vitals.withId(
      id,
      map['vitalName'],
      map['value'],
      map['user'],
      map['maxCriticalValue'],
      map['minCriticalValue'],
    );
  }
}
