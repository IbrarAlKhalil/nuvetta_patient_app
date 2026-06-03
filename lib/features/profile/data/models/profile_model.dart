class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phone;
  final String profileImage;
  final String gender;
  final DateTime? dateOfBirth;
  final String bloodType;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String insuranceProvider;
  final String insuranceId;
  final List<String> allergies;
  final List<String> chronicConditions;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.profileImage,
    required this.gender,
    required this.dateOfBirth,
    required this.bloodType,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.insuranceProvider,
    required this.insuranceId,
    required this.allergies,
    required this.chronicConditions,
  });

  String get fullName {
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Patient' : fullName;
  }

  String get formattedPhone {
    final rawPhone = phone.trim();
    final rawCountry = countryCode.trim();
    if (rawPhone.isEmpty) return rawCountry;
    if (rawPhone.startsWith(rawCountry)) return rawPhone;
    if (rawCountry.startsWith('+') && rawPhone.startsWith(rawCountry.substring(1))) {
      return '+$rawPhone';
    }
    return '$rawCountry$rawPhone';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString().trim();
    final parts = name.split(' ');
    final firstName = json['firstName']?.toString().trim().isNotEmpty == true
        ? json['firstName'].toString()
        : parts.isNotEmpty
            ? parts.first
            : '';
    final lastName = json['lastName']?.toString().trim().isNotEmpty == true
        ? json['lastName'].toString()
        : parts.length > 1
            ? parts.sublist(1).join(' ')
            : '';

    DateTime? dob;
    final dobValue = json['dateOfBirth'] ?? json['dob'];
    if (dobValue != null) {
      if (dobValue is String) {
        dob = DateTime.tryParse(dobValue);
      } else if (dobValue is int) {
        dob = DateTime.fromMillisecondsSinceEpoch(dobValue);
      }
    }

    return ProfileModel(
      id: json['id']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      email: json['email']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? json['dialCode']?.toString() ?? '+1',
      phone: json['phone']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? json['avatar']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dateOfBirth: dob,
      bloodType: json['bloodType']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipCode: json['zipCode']?.toString() ?? json['postalCode']?.toString() ?? '',
      insuranceProvider: json['insuranceProvider']?.toString() ?? '',
      insuranceId: json['insuranceId']?.toString() ?? '',
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      chronicConditions: (json['chronicConditions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'countryCode': countryCode,
      'phone': phone,
      'profileImage': profileImage,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodType': bloodType,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'insuranceProvider': insuranceProvider,
      'insuranceId': insuranceId,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
    };
  }
}
