import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nuveta_patient_app/features/profile/data/models/profile_model.dart';
import 'package:nuveta_patient_app/features/profile/data/models/record_model.dart';
import 'package:nuveta_patient_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:nuveta_patient_app/features/profile/widgets/profile_header.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';


class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    ProfileModel profile,
  ) async {
    final firstNameController = TextEditingController(text: profile.firstName);
    final lastNameController = TextEditingController(text: profile.lastName);
    final emailController = TextEditingController(text: profile.email);
    final countryCodeController = TextEditingController(text: profile.countryCode);
    final phoneController = TextEditingController(text: profile.phone);
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Enter a valid email';
                        }
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: countryCodeController,
                          decoration: const InputDecoration(labelText: 'Country Code'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter country code';
                            }
                            if (!RegExp(r'^\+\d{1,4}\$').hasMatch(value.trim())) {
                              return 'Use format +1';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter phone';
                            }
                            if (!RegExp(r'^[0-9]{6,15}\$').hasMatch(value.trim())) {
                              return 'Use digits only';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;
                try {
                  await ref.read(profileRepositoryProvider).updateProfile(
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        email: emailController.text.trim(),
                        countryCode: countryCodeController.text.trim(),
                        phone: phoneController.text.trim(),
                      );
                  ref.invalidate(profileProvider);
                  Navigator.pop(context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                  }
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Update failed: $error')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddRecordDialog(BuildContext context, WidgetRef ref) async {
    final typeController = TextEditingController();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    PlatformFile? selectedFile;
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Medical Record'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: typeController,
                        decoration: const InputDecoration(labelText: 'Record Type'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter record type';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a short description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Date:'),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  selectedDate = date;
                                });
                              }
                            },
                            child: Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.pickFiles(
  type: FileType.custom,
  allowMultiple: false,
  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
);
                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              selectedFile = result.files.first;
                            });
                          }
                        },
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Attach Image / PDF'),
                      ),
                      if (selectedFile != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Selected: ${selectedFile!.name}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    try {
                      await ref.read(profileRepositoryProvider).addRecord(
                            type: typeController.text.trim(),
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            date: selectedDate,
                            attachment: selectedFile,
                          );
                      ref.invalidate(profileRecordsProvider);
                      Navigator.pop(context);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Medical record added successfully')),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add record: $error')),
                        );
                      }
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecordCard(BuildContext context, RecordModel record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              record.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(record.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${record.date.day}/${record.date.month}/${record.date.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final recordsAsync = ref.watch(profileRecordsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('My Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider);
          ref.invalidate(profileRecordsProvider);
        },
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading profile: $e')),
          data: (profile) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  ProfileHeader(data: profile.toMap()),
                  const SizedBox(height: 18),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contact information', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('Email: ${profile.email.isNotEmpty ? profile.email : 'Not available'}'),
                          const SizedBox(height: 6),
                          Text('Phone: ${profile.countryCode}${profile.phone}'),
                          const SizedBox(height: 6),
                          if (profile.address.isNotEmpty) Text('Address: ${profile.address}'),
                          const SizedBox(height: 6),
                          if (profile.insuranceProvider.isNotEmpty) Text('Insurance: ${profile.insuranceProvider}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showEditProfileDialog(context, ref, profile),
                          child: const Text('Edit Profile'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showAddRecordDialog(context, ref),
                          child: const Text('Add Record'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  recordsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error loading records: $e')),
                    data: (records) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Medical Records', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          if (records.isEmpty)
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  children: [
                                    const Text('No records yet'),
                                    const SizedBox(height: 8),
                                    Text('Add a medical record to keep your history in sync with the clinic backend.', style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...records.map((record) => _buildRecordCard(context, record)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        elevation: 8,
                        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      ),
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
