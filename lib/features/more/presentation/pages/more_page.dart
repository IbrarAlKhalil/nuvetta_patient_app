import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
      ),

      body: ListView(
        children: [

          const SizedBox(height: 10),
          _buildTile(
            context,
            icon: Icons.person,
            title: "profile",
            route: "/profile",
          ),

          _buildTile(
            context,
            icon: Icons.search,
            title: "Search",
            route: "/search",
          ),

          _buildTile(
            context,
            icon: Icons.science,
            title: "Lab Tests",
            route: "/lab-tests",
          ),

          _buildTile(
            context,
            icon: Icons.notifications,
            title: "Notifications",
            route: "/notifications",
          ),

          _buildTile(
            context,
            icon: Icons.local_pharmacy,
            title: "Pharmacy",
            route: "/pharacy", 
          ),

          _buildTile(
            context,
            icon: Icons.help_outline,
            title: "Help & Support",
            route: null,
          ),

          _buildTile(
            context,
            icon: Icons.info_outline,
            title: "About App",
            route: null,
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (route != null) {
          context.push(route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$title coming soon")),
          );
        }
      },
    );
  }
}