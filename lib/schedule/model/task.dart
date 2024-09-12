class Task {
  const Task({
    required this.title,
    required this.note,
    required this.startTime,
    required this.endTime,
    required this.selectedDay,
    required this.remind,
    required this.color,
    this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as int,
        title: json['title'] as String,
        note: json['note'] as String,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        selectedDay: json['selectedDay'] as int,
        remind: json['remind'] as int,
        color: json['color'] as int,
      );

  final int? id;
  final String title;
  final String note;
  final String startTime;
  final String endTime;
  final int selectedDay;
  final int remind;
  final int color;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'startTime': startTime,
        'endTime': endTime,
        'selectedDay': selectedDay,
        'remind': remind,
        'color': color,
      };
}
