class Building {
  final int capacity;
  final String name;
  final List<Classroom> classrooms;

  Building(
      {required this.capacity, required this.name, required this.classrooms});

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

  List<Map<String, dynamic>> classroomsToJson() {
    List<Map<String, dynamic>> classroomList = [];
    for (var classroom in classrooms) {
      classroomList.add(classroom.toJson());
    }
    return classroomList;
  }

  List<Classroom> getClassroomsExcept(List<int> exceptClassrooms) {
    List<Classroom> result = [];
    for (var room in classrooms) {
      if (!exceptClassrooms.contains(room.number)) {
        result.add(room);
      }
    }
    return result;
  }
}

class Classroom {
  int currentCap;
  final int maxCap;
  final int number;

  Classroom(
      {required this.currentCap, required this.maxCap, required this.number});

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      currentCap: json['currentCap'] as int,
      maxCap: json['maxCap'] as int,
      number: json['number'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'currentCap': currentCap, 'maxCap': maxCap, 'number': number};
  }
}
