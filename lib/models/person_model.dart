enum Gender { male, female, other }

class Person {
  String id;
  String username;
  String email;
  // ignore: non_constant_identifier_names
  String profile_picture;
  int age;
  double height;
  double weight;
  Gender gender;
  String contactNumber;
  List<String> categories; // List of category IDs associated with the user

  Person(this.username, this.email, this.profile_picture, this.age, this.height,
      this.weight, this.gender, this.contactNumber, {this.categories = const []})
      : id = '';

  Person.withId(this.id, this.username, this.email, this.profile_picture,
      this.age, this.height, this.weight, this.gender, this.contactNumber,
      {this.categories = const []});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['profile_picture'] = profile_picture;
    map['age'] = age;
    map['height'] = height;
    map['weight'] = weight;
    map['contactNumber'] = contactNumber;
    map['gender'] = gender.toString().split('.').last;
    map['categories'] = categories; // Save the list of category IDs
    return map;
  }

  factory Person.fromMap(Map<String, dynamic> map, String id) {
    return Person.withId(
      id,
      map['username'],
      map['email'],
      map['profile_picture'],
      map['age'] ?? 0,
      map['height'] ?? 0,
      map['weight'] ?? 0,
      Gender.values.firstWhere(
          (e) => e.toString().split('.').last == map['gender'],
          orElse: () => Gender.other),
      map['contactNumber'] ?? '',
      categories: List<String>.from(map['categories'] ?? []), // Retrieve the list of category IDs
    );
  }
}
