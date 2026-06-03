class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final String status;
  final String type;
  final String location;
  final String notes;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.status,
    required this.type,
    required this.location,
    required this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.now();
    final rawDate = json['dateTime'] ?? json['scheduledAt'] ?? json['appointmentDate'];

    if (rawDate is String) {
      dateTime = DateTime.tryParse(rawDate) ?? dateTime;
    } else if (rawDate is int) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(rawDate);
    }

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? json['providerId']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? json['providerName']?.toString() ?? 'Doctor',
      specialty: json['specialty']?.toString() ?? json['specialtyName']?.toString() ?? '',
      dateTime: dateTime,
      status: json['status']?.toString() ?? 'pending',
      type: json['type']?.toString() ?? 'telehealth',
      location: json['location']?.toString() ?? 'Telehealth visit',
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialty': specialty,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'type': type,
      'location': location,
      'notes': notes,
    };
  }
}
