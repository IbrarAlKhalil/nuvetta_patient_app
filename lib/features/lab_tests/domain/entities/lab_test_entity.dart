class LabTestEntity {
  final String id;
  final String testName;
  final DateTime testDate;
  final String status;
  final Map<String, dynamic> results;
  final String labName;
  final String doctorReview;

  const LabTestEntity({
    required this.id,
    required this.testName,
    required this.testDate,
    required this.status,
    required this.results,
    required this.labName,
    required this.doctorReview,
  });
}

class LabBookingEntity {
  final String id;
  final String testName;
  final DateTime bookingDate;
  final String status;
  final String collectionType;
  final String address;
  final String labName;
  final double estimatedCost;
  final String instructions;

  const LabBookingEntity({
    required this.id,
    required this.testName,
    required this.bookingDate,
    required this.status,
    required this.collectionType,
    required this.address,
    required this.labName,
    required this.estimatedCost,
    required this.instructions,
  });
}
