import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';
import 'package:nuveta_patient_app/features/doctors/presentation/providers/doctors_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Doctors"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= SEARCH BOX =================
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase().trim();
                });
              },
              decoration: InputDecoration(
                hintText: "Search doctor or specialization...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= RESULTS =================
            Expanded(
              child: doctorsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),

                error: (e, _) =>
                    Center(child: Text("Error: $e")),

                data: (List<DoctorModel> doctors) {
                  final filtered = doctors.where((doctor) {
                    return doctor.name.toLowerCase().contains(query) ||
                        doctor.specialization.toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("No doctors found"),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final doctor = filtered[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          title: Text(doctor.name),
                          subtitle: Text(doctor.specialization),

                          // 🔥 BUTTON CHANGED: BOOK → VIEW
                          trailing: ElevatedButton(
                            onPressed: () {
                              context.push(
                                '/doctor-details',
                                extra: doctor, // ✅ PASS MODEL DIRECTLY
                              );
                            },
                            child: const Text("View"),
                          ),

                          onTap: () {
                            context.push(
                              '/doctor-details',
                              extra: doctor, // ✅ SAME HERE
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}