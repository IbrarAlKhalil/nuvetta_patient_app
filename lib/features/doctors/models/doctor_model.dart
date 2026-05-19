class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int experience;
  final bool online;
  final int patientsCount;
  final String about;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.experience,
    required this.online,
    required this.patientsCount,
    required this.about,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      online: json['online'] ?? false,
      patientsCount: (json['patientsCount'] as num?)?.toInt() ?? 0,
      about: json['about'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'rating': rating,
      'experience': experience,
      'online': online,
      'patientsCount': patientsCount,
      'about': about,
    };
  }

  /// ✅ IMPORTANT: fixes Dropdown crash
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  /// UI helper
  String get displayName => "$name - $specialization";
}