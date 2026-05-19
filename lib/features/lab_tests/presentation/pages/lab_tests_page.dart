import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nuveta_patient_app/features/lab_tests/domain/entities/lab_test_entity.dart';
import '../providers/lab_test_provider.dart';

class LabTestsPage extends ConsumerStatefulWidget {
  const LabTestsPage({super.key});

  @override
  ConsumerState<LabTestsPage> createState() => _LabTestsPageState();
}

class _LabTestsPageState extends ConsumerState<LabTestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labTestsAsync = ref.watch(labTestsProvider);
    final labBookingsAsync = ref.watch(labBookingsProvider);

    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tests'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Results'),
            Tab(text: 'Bookings'),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [

          // ================= RESULTS =================
          labTestsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),

            data: (List<LabTestEntity> labTests) {
              if (labTests.isEmpty) {
                return const Center(
                  child: Text('No lab results'),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(isMobile ? 12 : 24),
                itemCount: labTests.length,
                itemBuilder: (context, index) {
                  final test = labTests[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.science,
                          color: Colors.purple,
                        ),
                      ),

                      title: Text(
                        test.testName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        '${test.testDate.day}/${test.testDate.month}/${test.testDate.year}',
                      ),

                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ),

                      onTap: () {
                        context.push(
                          '/lab-test-detail',
                          extra: test,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),

          // ================= BOOKINGS =================
          labBookingsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),

            data: (bookings) {
              return ListView(
                padding: EdgeInsets.all(isMobile ? 12 : 24),
                children: [

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Book New Lab Test'),
                      onPressed: () {
                        context.push('/lab-booking');
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (bookings.isEmpty)
                    const Center(
                      child: Text('No lab bookings'),
                    )
                  else
                    ...bookings.map((booking) {
                      booking.bookingDate.isAfter(DateTime.now());

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                booking.testName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                              ),

                              const SizedBox(height: 8),

                              Text(
                                booking.collectionType,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                booking.labName,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '\$${booking.estimatedCost}',
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}