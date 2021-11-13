class Building {
  final int capacity;
  final String name;
  final List<Classroom> classrooms;

  Building({required this.capacity, required this.name, required this.classrooms});

  factory Building.fromJson(Map<String, dynamic> json) {
    List<Classroom> listClasrooms = <Classroom>[];

    var classes = json["classrooms"] as List<dynamic>?;

    if (classes != null) {
      listClasrooms =
          classes.map((classData) => Classroom.fromJson(classData)).toList();
    }

    return Building(
        capacity: json['Capacity'] as int,
        name: json['Name'] as String,
        classrooms: listClasrooms);
  }
}

class Classroom {
  final int? currentCap;
  final int? maxCap;
  final int? number;

  Classroom({this.currentCap, this.maxCap, this.number});

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      currentCap: json['currentCap'] as int?,
      maxCap: json['maxCap'] as int?,
      number: json['number'] as int?,
    );
  }
}
