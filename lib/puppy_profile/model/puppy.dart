class Puppy {

  const Puppy({
    required this.imagePath,
    required this.name,
    required this.owner,
    required this.birthdate,
    required this.ageInWeeks,
    required this.growthStage,
  });

  factory Puppy.fromJson(Map<String, dynamic> json) => Puppy(
        imagePath: json['imagePath'] as String,
        name: json['name'] as String,
        owner: json['owner'] as String,
        birthdate: json['birthdate'] as String,
        ageInWeeks: json['ageInWeeks'] as int,
        growthStage: json['growthStage'] as String,
      );
  final String imagePath;
  final String name;
  final String owner;
  final String birthdate;
  final int ageInWeeks;
  final String growthStage;

  Puppy copy({
    String? imagePath,
    String? name,
    String? owner,
    String? birthdate,
    int? ageInWeeks,
    String? growthStage,
  }) =>
      Puppy(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        owner: owner ?? this.owner,
        birthdate: birthdate ?? this.birthdate,
        ageInWeeks: ageInWeeks ?? this.ageInWeeks,
        growthStage: growthStage ?? this.growthStage,
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'owner': owner,
        'birthdate': birthdate,
        'ageInWeeks': ageInWeeks,
        'growthStage': growthStage,
      };
}
