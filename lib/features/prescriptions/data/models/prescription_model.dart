import '../../domain/entities/prescription_entity.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.medicationName,
    required super.dosage,
    required super.frequency,
    required super.quantity,
    required super.prescribedDate,
    required super.expiryDate,
    required super.doctorName,
    required super.purpose,
    required super.refillsLeft,
    required super.instructions,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      quantity: json['quantity'] as int,
      prescribedDate: json['prescribedDate'] is DateTime
          ? json['prescribedDate'] as DateTime
          : DateTime.parse(json['prescribedDate'].toString()),
      expiryDate: json['expiryDate'] is DateTime
          ? json['expiryDate'] as DateTime
          : DateTime.parse(json['expiryDate'].toString()),
      doctorName: json['doctorName'] as String,
      purpose: json['purpose'] as String,
      refillsLeft: json['refillsLeft'] as int,
      instructions: json['instructions'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicationName': medicationName,
    'dosage': dosage,
    'frequency': frequency,
    'quantity': quantity,
    'prescribedDate': prescribedDate.toIso8601String(),
    'expiryDate': expiryDate.toIso8601String(),
    'doctorName': doctorName,
    'purpose': purpose,
    'refillsLeft': refillsLeft,
    'instructions': instructions,
  };
}
