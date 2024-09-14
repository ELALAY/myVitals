class Vitals {
  String id;
  String vitalName;
  double value;
  String user;
  double maxCriticalValue;
  double minCriticalValue;

  Vitals(this.vitalName, this.value, this.user, this.maxCriticalValue,
      this.minCriticalValue)
      : id = '';

  Vitals.withId(this.id, this.vitalName, this.value, this.user,
      this.maxCriticalValue, this.minCriticalValue);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['vitalName'] = vitalName;
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
