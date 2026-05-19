// Mock data generator for all features
import 'package:uuid/uuid.dart';

class MockDataGenerator {
  static const uuid = Uuid();

  // ==================== APPOINTMENTS ====================
  static List<Map<String, dynamic>> generateAppointments() {
    final now = DateTime.now();
    return [
      {
        'id': uuid.v4(),
        'doctorName': 'Dr. Sarah Johnson',
        'specialty': 'Cardiologist',
        'dateTime': now.add(const Duration(days: 2)),
        'status': 'scheduled',
        'type': 'telehealth',
        'notes': 'Telehealth video consultation',
        'location': 'Telehealth visit',
        'doctorImage': 'assets/doctor_1.jpg',
      },
      {
        'id': uuid.v4(),
        'doctorName': 'Dr. Michael Chen',
        'specialty': 'Neurologist',
        'dateTime': now.add(const Duration(days: 7)),
        'status': 'scheduled',
        'type': 'home_visit',
        'notes': 'Home visit requested',
        'location': 'Home visit',
        'doctorImage': 'assets/doctor_2.jpg',
      },
      {
        'id': uuid.v4(),
        'doctorName': 'Dr. Emily Rodriguez',
        'specialty': 'Dermatologist',
        'dateTime': now.subtract(const Duration(days: 5)),
        'status': 'completed',
        'type': 'in_clinic',
        'notes': 'Skin treatment',
        'location': 'Derma Clinic, Room 102',
        'doctorImage': 'assets/doctor_3.jpg',
      },
      {
        'id': uuid.v4(),
        'doctorName': 'Dr. James Wilson',
        'specialty': 'Orthopedist',
        'dateTime': now.subtract(const Duration(days: 15)),
        'status': 'completed',
        'type': 'in_clinic',
        'notes': 'Knee pain assessment',
        'location': 'Orthopedic Center, Room 401',
        'doctorImage': 'assets/doctor_4.jpg',
      },
    ];
  }

  // ==================== MEDICAL HISTORY ====================
  static List<Map<String, dynamic>> generateMedicalHistory() {
    return [
      {
        'id': uuid.v4(),
        'condition': 'Hypertension',
        'startDate': DateTime(2020, 3, 15),
        'endDate': null,
        'status': 'ongoing',
        'treatment': 'Amlodipine 5mg daily',
        'notes': 'Blood pressure controlled',
      },
      {
        'id': uuid.v4(),
        'condition': 'Type 2 Diabetes',
        'startDate': DateTime(2019, 6, 20),
        'endDate': null,
        'status': 'ongoing',
        'treatment': 'Metformin 1000mg twice daily',
        'notes': 'HbA1c levels improving',
      },
      {
        'id': uuid.v4(),
        'condition': 'Allergy to Penicillin',
        'startDate': DateTime(2018, 1, 10),
        'endDate': null,
        'status': 'ongoing',
        'treatment': 'Avoid Penicillin and related antibiotics',
        'notes': 'Severe reaction - use Azithromycin instead',
      },
      {
        'id': uuid.v4(),
        'condition': 'Appendicitis',
        'startDate': DateTime(2015, 5, 12),
        'endDate': DateTime(2015, 5, 13),
        'status': 'resolved',
        'treatment': 'Emergency appendectomy',
        'notes': 'Surgery successful, full recovery',
      },
    ];
  }

  // ==================== PRESCRIPTIONS ====================
  static List<Map<String, dynamic>> generatePrescriptions() {
    final now = DateTime.now();
    return [
      {
        'id': uuid.v4(),
        'medicationName': 'Amlodipine',
        'dosage': '5mg',
        'frequency': 'Once daily',
        'quantity': 30,
        'prescribedDate': now.subtract(const Duration(days: 30)),
        'expiryDate': now.add(const Duration(days: 330)),
        'doctorName': 'Dr. Sarah Johnson',
        'purpose': 'Blood pressure management',
        'refillsLeft': 2,
        'instructions': 'Take in the morning with food',
      },
      {
        'id': uuid.v4(),
        'medicationName': 'Metformin',
        'dosage': '1000mg',
        'frequency': 'Twice daily',
        'quantity': 60,
        'prescribedDate': now.subtract(const Duration(days: 45)),
        'expiryDate': now.add(const Duration(days: 315)),
        'doctorName': 'Dr. Sarah Johnson',
        'purpose': 'Diabetes management',
        'refillsLeft': 3,
        'instructions': 'Take with meals to avoid stomach upset',
      },
      {
        'id': uuid.v4(),
        'medicationName': 'Atorvastatin',
        'dosage': '20mg',
        'frequency': 'Once daily',
        'quantity': 30,
        'prescribedDate': now.subtract(const Duration(days: 60)),
        'expiryDate': now.add(const Duration(days: 300)),
        'doctorName': 'Dr. Michael Chen',
        'purpose': 'Cholesterol management',
        'refillsLeft': 1,
        'instructions': 'Take at night',
      },
      {
        'id': uuid.v4(),
        'medicationName': 'Lisinopril',
        'dosage': '10mg',
        'frequency': 'Once daily',
        'quantity': 30,
        'prescribedDate': now.subtract(const Duration(days: 90)),
        'expiryDate': now.add(const Duration(days: 270)),
        'doctorName': 'Dr. Sarah Johnson',
        'purpose': 'Blood pressure and heart health',
        'refillsLeft': 0,
        'instructions': 'Take in the morning',
      },
    ];
  }

  // ==================== LAB RESULTS ====================
  static List<Map<String, dynamic>> generateLabResults() {
    return [
      {
        'id': uuid.v4(),
        'testName': 'Complete Blood Count (CBC)',
        'testDate': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'completed',
        'results': {
          'hemoglobin': {'value': '14.5', 'unit': 'g/dL', 'normal': '13.5-17.5'},
          'whiteBloodCells': {'value': '7.2', 'unit': '10^3/uL', 'normal': '4.5-11.0'},
          'platelets': {'value': '250', 'unit': '10^3/uL', 'normal': '150-400'},
        },
        'labName': 'City Diagnostic Lab',
        'doctorReview': 'All values normal',
      },
      {
        'id': uuid.v4(),
        'testName': 'Fasting Blood Sugar',
        'testDate': DateTime.now().subtract(const Duration(days: 10)),
        'status': 'completed',
        'results': {
          'glucose': {'value': '112', 'unit': 'mg/dL', 'normal': '70-100'},
        },
        'labName': 'City Diagnostic Lab',
        'doctorReview': 'Slightly elevated, monitor diet',
      },
      {
        'id': uuid.v4(),
        'testName': 'Lipid Panel',
        'testDate': DateTime.now().subtract(const Duration(days: 20)),
        'status': 'completed',
        'results': {
          'totalCholesterol': {'value': '180', 'unit': 'mg/dL', 'normal': '<200'},
          'ldl': {'value': '110', 'unit': 'mg/dL', 'normal': '<130'},
          'hdl': {'value': '45', 'unit': 'mg/dL', 'normal': '>40'},
          'triglycerides': {'value': '140', 'unit': 'mg/dL', 'normal': '<150'},
        },
        'labName': 'City Diagnostic Lab',
        'doctorReview': 'Good lipid profile',
      },
    ];
  }

  // ==================== LAB BOOKINGS ====================
  static List<Map<String, dynamic>> generateLabBookings() {
    final now = DateTime.now();
    return [
      {
        'id': uuid.v4(),
        'testName': 'Complete Blood Count (CBC)',
        'bookingDate': now.add(const Duration(days: 3)),
        'status': 'confirmed',
        'collectionType': 'home_sample',
        'address': '123 Main St, Apt 4B, New York, NY 10001',
        'labName': 'City Diagnostic Lab',
        'estimatedCost': 50,
        'instructions': 'Fast for 8 hours before collection',
      },
      {
        'id': uuid.v4(),
        'testName': 'Thyroid Panel (TSH, T3, T4)',
        'bookingDate': now.add(const Duration(days: 7)),
        'status': 'pending',
        'collectionType': 'clinic',
        'address': 'City Diagnostic Lab, 456 Health Ave',
        'labName': 'City Diagnostic Lab',
        'estimatedCost': 75,
        'instructions': 'Fast for 8 hours before test',
      },
    ];
  }

  // ==================== MESSAGES ====================
  static List<Map<String, dynamic>> generateMessages() {
    final now = DateTime.now();
    return [
      {
        'id': uuid.v4(),
        'senderName': 'Dr. Sarah Johnson',
        'senderRole': 'Doctor',
        'senderImage': 'assets/doctor_1.jpg',
        'lastMessage': 'How are you feeling today?',
        'lastMessageTime': now.subtract(const Duration(hours: 2)),
        'unreadCount': 1,
        'messages': [
          {
            'id': uuid.v4(),
            'sender': 'Dr. Sarah Johnson',
            'message': 'Hi! Just checking in on your progress.',
            'timestamp': now.subtract(const Duration(hours: 3)),
            'isUser': false,
          },
          {
            'id': uuid.v4(),
            'sender': 'You',
            'message': 'Doing well, blood pressure readings are stable.',
            'timestamp': now.subtract(const Duration(hours: 2, minutes: 30)),
            'isUser': true,
          },
          {
            'id': uuid.v4(),
            'sender': 'Dr. Sarah Johnson',
            'message': 'How are you feeling today?',
            'timestamp': now.subtract(const Duration(hours: 2)),
            'isUser': false,
          },
        ],
      },
      {
        'id': uuid.v4(),
        'senderName': 'Dr. Michael Chen',
        'senderRole': 'Doctor',
        'senderImage': 'assets/doctor_2.jpg',
        'lastMessage': 'Please bring recent lab reports',
        'lastMessageTime': now.subtract(const Duration(days: 1)),
        'unreadCount': 0,
        'messages': [
          {
            'id': uuid.v4(),
            'sender': 'Dr. Michael Chen',
            'message': 'Please bring recent lab reports to your appointment.',
            'timestamp': now.subtract(const Duration(days: 1)),
            'isUser': false,
          },
        ],
      },
      {
        'id': uuid.v4(),
        'senderName': 'Hospital Admin',
        'senderRole': 'Admin',
        'senderImage': 'assets/hospital.jpg',
        'lastMessage': 'Your appointment confirmation',
        'lastMessageTime': now.subtract(const Duration(days: 2)),
        'unreadCount': 0,
        'messages': [
          {
            'id': uuid.v4(),
            'sender': 'Hospital Admin',
            'message': 'Your appointment with Dr. Sarah Johnson is confirmed for tomorrow at 2:00 PM.',
            'timestamp': now.subtract(const Duration(days: 2)),
            'isUser': false,
          },
        ],
      },
    ];
  }

  // ==================== NOTIFICATIONS ====================
  static List<Map<String, dynamic>> generateNotifications() {
    final now = DateTime.now();
    return [
      {
        'id': uuid.v4(),
        'title': 'Appointment Reminder',
        'message': 'You have an appointment with Dr. Sarah Johnson tomorrow at 2:00 PM',
        'timestamp': now.subtract(const Duration(hours: 1)),
        'type': 'appointment',
        'isRead': false,
        'actionUrl': '/appointments',
      },
      {
        'id': uuid.v4(),
        'title': 'Lab Results Available',
        'message': 'Your Complete Blood Count results are ready. Please review them.',
        'timestamp': now.subtract(const Duration(days: 1)),
        'type': 'lab',
        'isRead': false,
        'actionUrl': '/lab-tests',
      },
      {
        'id': uuid.v4(),
        'title': 'Prescription Reminder',
        'message': 'Time to refill your Amlodipine prescription',
        'timestamp': now.subtract(const Duration(days: 2)),
        'type': 'prescription',
        'isRead': true,
        'actionUrl': '/prescriptions',
      },
      {
        'id': uuid.v4(),
        'title': 'Health Tip',
        'message': 'Remember to stay hydrated and exercise regularly for better health.',
        'timestamp': now.subtract(const Duration(days: 3)),
        'type': 'health_tip',
        'isRead': true,
        'actionUrl': null,
      },
      {
        'id': uuid.v4(),
        'title': 'Medication Interaction Alert',
        'message': 'Check the interaction between two of your medications',
        'timestamp': now.subtract(const Duration(days: 5)),
        'type': 'alert',
        'isRead': true,
        'actionUrl': '/prescriptions',
      },
    ];
  }

  // ==================== PATIENT INFORMATION ====================
  static Map<String, dynamic> generatePatientInfo() {
    return {
      'id': uuid.v4(),
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@email.com',
      'phone': '+1 (555) 123-4567',
      'dateOfBirth': DateTime(1985, 5, 15),
      'gender': 'Male',
      'bloodType': 'O+',
      'height': 180,
      'weight': 80,
      'address': '123 Main Street, New York, NY 10001',
      'city': 'New York',
      'state': 'NY',
      'zipCode': '10001',
      'emergencyContact': 'Jane Doe',
      'emergencyPhone': '+1 (555) 987-6543',
      'relationshipToEmergencyContact': 'Spouse',
      'insuranceProvider': 'Blue Cross Blue Shield',
      'insuranceId': 'BCS123456789',
      'allergies': ['Penicillin', 'Aspirin'],
      'chronicConditions': ['Hypertension', 'Type 2 Diabetes'],
      'profileImage': 'assets/profile_placeholder.jpg',
    };
  }
}
