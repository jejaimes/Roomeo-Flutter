class User {
  final String faculty;
  final String lastHW;
  final String login;
  final String name;
  final String uniandesId;
  final List<String> classrooms;

  User(
      {required this.faculty,
      required this.lastHW,
      required this.login,
      required this.name,
      required this.uniandesId,
      required this.classrooms});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        faculty: json['Faculty'],
        lastHW: json['LastHW'],
        login: json['Login'],
        name: json['Name'],
        uniandesId: json['UniandesID'],
        classrooms: json['classrooms']);
  }
  Map<String, dynamic> toJson() {
    return {
      'Faculty': faculty,
      'LastHW': lastHW,
      'Login': login,
      'Name': name,
      'UniandesID': uniandesId,
      'classrooms': classrooms
    };
  }
}
