import '../../domain/entities/lab_test_entity.dart';

class LabTestModel extends LabTestEntity {
  const LabTestModel({
    required super.id,
    required super.testName,
    required super.testDate,
    required super.status,
    required super.results,
    required super.labName,
    required super.doctorReview,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    return LabTestModel(
      id: json['id'] as String,
      testName: json['testName'] as String,
      testDate: json['testDate'] is DateTime
    ? json['testDate'] as DateTime
    : DateTime.parse(json['testDate'].toString()),
      status: json['status'] as String,
      results: json['results'] as Map<String, dynamic>,
      labName: json['labName'] as String,
      doctorReview: json['doctorReview'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'testName': testName,
    'testDate': testDate.toIso8601String(),
    'status': status,
    'results': results,
    'labName': labName,
    'doctorReview': doctorReview,
  };
}

class LabBookingModel extends LabBookingEntity {
  const LabBookingModel({
    required super.id,
    required super.testName,
    required super.bookingDate,
    required super.status,
    required super.collectionType,
    required super.address,
    required super.labName,
    required super.estimatedCost,
    required super.instructions,
  });

  factory LabBookingModel.fromJson(Map<String, dynamic> json) {
    return LabBookingModel(
      id: json['id'] as String,
      testName: json['testName'] as String,
      bookingDate: json['bookingDate'] is DateTime
    ? json['bookingDate'] as DateTime
    : DateTime.parse(json['bookingDate'].toString()),
      status: json['status'] as String,
      collectionType: json['collectionType'] as String,
      address: json['address'] as String,
      labName: json['labName'] as String,
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      instructions: json['instructions'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'testName': testName,
    'bookingDate': bookingDate.toIso8601String(),
    'status': status,
    'collectionType': collectionType,
    'address': address,
    'labName': labName,
    'estimatedCost': estimatedCost,
    'instructions': instructions,
  };
}
