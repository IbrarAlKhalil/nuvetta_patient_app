import '../../domain/entities/medical_history_entity.dart';


class MedicalHistoryModel extends MedicalHistoryEntity {
  const MedicalHistoryModel({
    required super.id,
    required super.condition,
    required super.startDate,
    super.endDate,
    required super.status,
    required super.treatment,
    required super.notes,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryModel(
      id: json['id'] as String,
      condition: json['condition'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      status: json['status'] as String,
      treatment: json['treatment'] as String,
      notes: json['notes'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'condition': condition,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'status': status,
    'treatment': treatment,
    'notes': notes,
  };
}
