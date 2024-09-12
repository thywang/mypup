import 'package:cloud_firestore/cloud_firestore.dart';

class Tip {
  const Tip({
    required this.title,
    required this.description,
    required this.infancy,
    required this.terribleTwos,
    required this.adolescent,
    required this.puberty,
    required this.teen,
    this.steps,
    this.video,
  });

  factory Tip.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Tip(
      title: data?['title'] as String,
      description: data?['description'] as String,
      steps: data?['steps'] is Iterable
          ? List.from(data?['steps'] as Iterable)
          : null,
      infancy: data?['infancy'] as bool,
      terribleTwos: data?['terribleTwos'] as bool,
      adolescent: data?['adolescent'] as bool,
      puberty: data?['puberty'] as bool,
      teen: data?['teen'] as bool,
      video: data?['video'] is String ? (data?['video'] as String) : null,
    );
  }
  final String title;
  final String description;
  final List<String>? steps;
  final bool infancy;
  final bool terribleTwos;
  final bool adolescent;
  final bool puberty;
  final bool teen;
  final String? video;

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      if (steps != null) 'steps': steps,
      'infancy': infancy,
      'terribleTwos': terribleTwos,
      'adolescent': adolescent,
      'puberty': puberty,
      'teen': teen,
      if (video != null) 'video': video,
    };
  }

  @override
  String toString() => 'Tip(title: $title, description: $description)';
}
