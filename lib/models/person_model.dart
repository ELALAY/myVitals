class Person {
  String id;
  String username;
  String email;
  // ignore: non_constant_identifier_names
  String profile_picture;
  int age;
  double height;
  double weight;
  List<String> categories; // List of category IDs associated with the user

  Person(this.username, this.email, this.profile_picture, this.age, this.height,
      this.weight, {this.categories = const []})
      : id = '';

  Person.withId(this.id, this.username, this.email, this.profile_picture,
      this.age, this.height, this.weight,
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
      categories: List<String>.from(map['categories'] ?? []), // Retrieve the list of category IDs
    );
  }
}
