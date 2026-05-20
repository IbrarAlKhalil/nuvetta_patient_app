import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map data;

  const ProfileHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFFA5B4FC)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.32), width: 2),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                data['profileImage'] != null && data['profileImage'].toString().startsWith('http')
                    ? data['profileImage']
                    : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&q=80&w=400&auto=format&fit=crop&cs=tinysrgb',
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data['firstName']} ${data['lastName']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Patient ID: ${data['id'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 0.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
