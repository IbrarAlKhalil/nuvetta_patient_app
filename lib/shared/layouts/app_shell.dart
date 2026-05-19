import 'package:flutter/material.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/doctors/presentation/doctors_page.dart';
import '../../features/appointments/presentation/pages/appointments_page.dart';
import '../../features/more/presentation/pages/more_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    DoctorsPage(),
    AppointmentsPage(),
    MorePage(), // 👈 everything else goes here
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      body: pages[currentIndex],

      // ================= MOBILE BOTTOM NAV =================
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey.shade600,

              onTap: (index) {
                setState(() => currentIndex = index);
              },

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_hospital),
                  label: "Doctors",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: "Appointments",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  label: "More",
                ),
              ],
            )

          // ================= DESKTOP NAV =================
          : Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                        _navItem(0, Icons.home, "Home"),
                        _navItem(1, Icons.local_hospital, "Doctors"),
                        _navItem(2, Icons.calendar_month, "Appointments"),
                        _navItem(3, Icons.more_horiz, "More"),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = currentIndex == index;

    return TextButton.icon(
      onPressed: () => setState(() => currentIndex = index),
      icon: Icon(
        icon,
        color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}