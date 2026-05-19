import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nuveta_patient_app/features/doctors/presentation/providers/doctors_provider.dart';
import 'package:nuveta_patient_app/features/home/presentation/widgets/action_card.dart';
import 'package:nuveta_patient_app/features/home/presentation/widgets/doctor_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Nuvetta",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Hello 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "How are you feeling today?",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            // ================= SEARCH =================
            GestureDetector(
              onTap: () => context.push('/search'),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search doctors, specializations...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ================= QUICK ACTIONS =================
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              children: [
                ActionCard(
                  icon: Icons.calendar_month,
                  title: "Book Appointment",
                  onTap: () => context.push('/appointments'),
                ),
                ActionCard(
                  icon: Icons.local_hospital,
                  title: "Find Doctors",
                  onTap: () => context.push('/doctors'),
                ),
                ActionCard(
                  icon: Icons.local_pharmacy,
                  title: "Pharmacy",
                  onTap: () {
                    context.push('/pharacy');
                  },
                ),
                ActionCard(
                  icon: Icons.science,
                  title: "Lab Tests",
                  onTap: () => context.push('/lab-tests'),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= DOCTORS =================
            const Text(
              "Featured Doctors",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            doctorsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),

              error: (e, _) => Text(
                "Error: $e",
                style: const TextStyle(color: Colors.red),
              ),

              data: (doctors) {
                return Column(
                  children: doctors.map((doctor) {
                    return DoctorCard(
                      name: doctor.name,
                      specialty: doctor.specialization,
                      experience: doctor.experience,
                      online: doctor.online,
                      onTap: () {
                        // IMPORTANT: DoctorModel passed directly
                        context.push('/doctor-details', extra: doctor);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}