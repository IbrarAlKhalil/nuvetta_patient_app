
import 'package:flutter/material.dart';
import 'package:nuveta_patient_app/features/appointments/presentation/widgets/book_appointment_sheet.dart';

import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';


class DoctorDetailsPage extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsPage({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Doctor Details"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= DOCTOR CARD =================

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [

                  Stack(
                    children: [

                      CircleAvatar(
                        radius: 45,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&q=80&w=400&auto=format&fit=crop&cs=tinysrgb',
                        ),
                        backgroundColor: Colors.transparent,
                      ),

                      Positioned(
                        right: 4,
                        bottom: 4,

                        child: Container(
                          width: 14,
                          height: 14,

                          decoration: BoxDecoration(
                            color: doctor.online ? Colors.greenAccent : Colors.grey.shade400,
                            shape: BoxShape.circle,

                            border: Border.all(
                              color: Theme.of(context).cardColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    doctor.specialization,
                    style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,

                    children: [

                      _InfoTile(
                        icon: Icons.work,
                        title: "Experience",
                        value:
                        "${doctor.experience} yrs",
                      ),

                      _InfoTile(
                        icon: Icons.star,
                        title: "Rating",
                        value:
                        doctor.rating.toString(),
                      ),

                      _InfoTile(
                        icon: Icons.people,
                        title: "Patients",
                        value:
                        "${doctor.patientsCount}+",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= ABOUT =================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    doctor.about,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= BOOK BUTTON =================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,

                    builder: (_) => BookAppointmentSheet(
  preSelectedDoctor: doctor,
),
                  );
                },

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  "Book Appointment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= INFO TILE =================

class _InfoTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}