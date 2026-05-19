class MedicalHistoryEntity {
  final String id;
  final String condition;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final String treatment;
  final String notes;

  const MedicalHistoryEntity({
    required this.id,
    required this.condition,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.treatment,
    required this.notes,
  });
}
