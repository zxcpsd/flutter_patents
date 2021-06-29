class Inventor {
  int testVariable;
  int id;
  String invId;
  String firstName;
  String lastName;
  String get name => '$firstName $lastName';
  Inventor(this.id, this.invId, this.firstName, this.lastName);
  Map<String, dynamic> toMap() => {
        'id': (id == 0) ? null : id,
        'invid': invId,
        'firstname': firstName,
        'lastname': lastName
      };
  Inventor.fromJson(Map<String, dynamic> parsedJson) {
    this.id = 0;
    this.invId = parsedJson['inventor_id'];
    this.firstName = parsedJson['inventor_first_name'];
    this.lastName = parsedJson['inventor_last_name'];
  }
  static String getAuthorsSubtitle(List<Inventor> list) =>
      List.generate(list.length, (index) => list[index].name).join(', ');
}
