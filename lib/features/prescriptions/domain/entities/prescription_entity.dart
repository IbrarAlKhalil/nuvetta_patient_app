class PrescriptionEntity {
  final String id;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int quantity;
  final DateTime prescribedDate;
  final DateTime expiryDate;
  final String doctorName;
  final String purpose;
  final int refillsLeft;
  final String instructions;

  const PrescriptionEntity({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.quantity,
    required this.prescribedDate,
    required this.expiryDate,
    required this.doctorName,
    required this.purpose,
    required this.refillsLeft,
    required this.instructions,
  });
}
