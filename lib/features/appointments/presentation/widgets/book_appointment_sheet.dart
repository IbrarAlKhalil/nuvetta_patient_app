import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';

class BookAppointmentSheet extends StatefulWidget {
  final DoctorModel? preSelectedDoctor;
  final void Function(Map<String, dynamic> appointment)? onBooked;

  const BookAppointmentSheet({
    super.key,
    this.preSelectedDoctor,
    this.onBooked,
  });

  @override
  State<BookAppointmentSheet> createState() =>
      _BookAppointmentSheetState();
}

class _BookAppointmentSheetState extends State<BookAppointmentSheet> {

  DoctorModel? _selectedDoctor;
  DateTime? _selectedDate;
  String? _selectedTime;
  String _selectedServiceType = 'telehealth';
  final TextEditingController _homeLocationController = TextEditingController();
  final String _clinicLocation = 'Nuveta Clinic, 123 Health Ave';

  final List<Map<String, String>> _serviceTypes = [
    {'id': 'telehealth', 'label': 'Telehealth'},
    {'id': 'home_visit', 'label': 'Home Visit'},
    {'id': 'in_clinic', 'label': 'In-Clinic'},
  ];

  final List<DoctorModel> _doctors = [
    DoctorModel(
      id: "1",
      name: "Dr. Sarah Johnson",
      specialization: "Cardiologist",
      rating: 4.8,
      experience: 10,
      online: true,
      patientsCount: 1200,
      about: "Heart specialist",
    ),
    DoctorModel(
      id: "2",
      name: "Dr. Michael Chen",
      specialization: "Neurologist",
      rating: 4.6,
      experience: 8,
      online: false,
      patientsCount: 900,
      about: "Brain specialist",
    ),
  ];

  final List<String> _times = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  void initState() {
    super.initState();

    // ✅ FIX: match by ID (not object reference)
    if (widget.preSelectedDoctor != null) {
      _selectedDoctor = _doctors.firstWhere(
        (d) => d.id == widget.preSelectedDoctor!.id,
        orElse: () => _doctors.first,
      );
    }
  }

  @override
  void dispose() {
    _homeLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isMobile = MediaQuery.of(context).size.width < 768;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,

      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),

          child: ListView(
            controller: scrollController,
            children: [

              const SizedBox(height: 10),

              Text(
                'Book Appointment',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              // ================= DOCTOR =================
              Text(
                'Select Doctor',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<DoctorModel>(
                value: _selectedDoctor,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                hint: const Text('Choose Doctor'),

                items: _doctors.map((doctor) {
                  return DropdownMenuItem(
                    value: doctor,
                    child: Text(doctor.displayName),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // ================= SERVICE TYPE =================
              Text(
                'Appointment Type',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _serviceTypes.map((type) {
                  final selected = _selectedServiceType == type['id'];
                  return ChoiceChip(
                    label: Text(type['label']!),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedServiceType = type['id']!;
                        if (_selectedServiceType != 'home_visit') {
                          _homeLocationController.clear();
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              if (_selectedServiceType == 'home_visit') ...[
                Text(
                  'Home Visit Location',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _homeLocationController,
                  decoration: InputDecoration(
                    hintText: 'Enter your home address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
              ] else if (_selectedServiceType == 'in_clinic') ...[
                Text(
                  'Clinic Location',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_clinicLocation),
                ),
                const SizedBox(height: 24),
              ] else ...[
                const SizedBox(height: 24),
              ],

              // ================= DATE =================
              Text(
                'Select Date',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(
                      const Duration(days: 1),
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 30),
                    ),
                  );

                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Choose Date'
                        : DateFormat('dd MMM yyyy').format(_selectedDate!),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= TIME =================
              Text(
                'Available Time Slots',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                children: _times.map((time) {

                  final selected = _selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedTime = time);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // ================= BUTTON =================
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (_selectedDoctor != null &&
                          _selectedDate != null &&
                          _selectedTime != null &&
                          (_selectedServiceType != 'home_visit' ||
                              _homeLocationController.text.trim().isNotEmpty))
                      ? () {
                          final selectedDate = _selectedDate!;
                          final selectedTime = DateFormat('hh:mm a')
                              .parse(_selectedTime!);
                          final appointmentDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          final location = _selectedServiceType == 'telehealth'
                              ? 'Telehealth visit'
                              : _selectedServiceType == 'home_visit'
                                  ? _homeLocationController.text.trim()
                                  : _clinicLocation;

                          final appointment = {
                            'id': DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            'doctorName': _selectedDoctor!.displayName,
                            'specialty': _selectedDoctor!.specialization,
                            'dateTime': appointmentDateTime,
                            'status': 'pending',
                            'type': _selectedServiceType,
                            'notes': _selectedServiceType == 'telehealth'
                                ? 'Telehealth video visit'
                                : _selectedServiceType == 'home_visit'
                                    ? 'Home visit requested'
                                    : 'In-clinic appointment',
                            'location': location,
                          };

                          widget.onBooked?.call(appointment);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Appointment Booked Successfully',
                              ),
                            ),
                          );

                          Navigator.pop(context);
                        }
                      : null,

                  child: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}