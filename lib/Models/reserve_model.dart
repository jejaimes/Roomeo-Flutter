class Reserve {
  final int day;
  final int hour;
  final int minute;
  final int month;
  final String name;
  final String room;
  final int year;
  final String? documentId;

  Reserve(
      {required this.day,
      required this.hour,
      required this.minute,
      required this.month,
      required this.name,
      required this.room,
      required this.year,
      this.documentId});

  factory Reserve.fromJson(Map<String, dynamic> json) {
    return Reserve(
      day: json['day'] as int,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      month: json['month'] as int,
      name: json['name'] as String,
      room: json['room'] as String,
      year: json['year'] as int,
      documentId:
          '${json['name']}-${json['room']}-${json['day']}-${json['month']}-${json['hour']}-${json['minute']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'hour': hour,
      'minute': minute,
      'month': month,
      'name': name,
      'room': room,
      'year': year
    };
  }
}
