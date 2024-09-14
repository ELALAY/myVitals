class VitalsModel {
  String id;
  String vitalCategory;
  double value;
  String user;
  DateTime date;

  VitalsModel(this.vitalCategory, this.value, this.user, this.date) : id = '';

  VitalsModel.withId(
      this.id, this.vitalCategory, this.value, this.user, this.date);

  Map<String, dynamic> toMap() {
    return {
      'vitalCategory': vitalCategory,
      'value': value,
      'user': user,
      'date': date.toIso8601String(), // Store date as an ISO 8601 string
    };
  }

  factory VitalsModel.fromMap(Map<String, dynamic> map, String id) {
    return VitalsModel.withId(
      id,
      map['vitalCategory'],
      map['value'],
      map['user'],
      // Convert the stored date back into a DateTime object
      DateTime.parse(map['date']),
    );
  }
}
