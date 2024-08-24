class Person {
  String id;
  String username;
  String email;
  String profilePicture;
  int age;
  double height;
  double weight;

  Person(this.username, this.email, this.profilePicture, this.age, this.height,
      this.weight)
      : id = '';
  Person.withId(this.id, this.username, this.email, this.profilePicture,
      this.age, this.height, this.weight);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['profile_picture'] = profilePicture;
    map['age'] = age;
    map['height'] = height;
    map['weight'] = weight;

    return map;
  }

  factory Person.fromMap(Map<String, dynamic> map, String id) {
    return Person.withId(
      id,
      map['username'],
      map['email'],
      map['profile_picture'],
      map['age'],
      map['height'],
      map['weight'],
    );
  }
}
