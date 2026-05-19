import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  late List<Map<String, dynamic>> notifications;
  late List<Map<String, dynamic>> filteredNotifications;
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    notifications = MockDataGenerator.generateNotifications();
    filteredNotifications = notifications;
  }

  void _filterNotifications(String type) {
    setState(() {
      _filterType = type;
      if (type == 'all') {
        filteredNotifications = notifications;
      } else {
        filteredNotifications = notifications.where((n) => n['type'] == type).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification['isRead'] = true;
                }
                filteredNotifications = notifications;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(isMobile ? 8 : 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filterType == 'all',
                  onPressed: () => _filterNotifications('all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Appointments',
                  isSelected: _filterType == 'appointment',
                  onPressed: () => _filterNotifications('appointment'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Labs',
                  isSelected: _filterType == 'lab',
                  onPressed: () => _filterNotifications('lab'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Prescriptions',
                  isSelected: _filterType == 'prescription',
                  onPressed: () => _filterNotifications('prescription'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Alerts',
                  isSelected: _filterType == 'alert',
                  onPressed: () => _filterNotifications('alert'),
                ),
              ],
            ),
          ),
          
          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      final timeFormatter = DateFormat('dd MMM, HH:mm');
                      final isRead = notification['isRead'] as bool;

                      return _NotificationTile(
                        notification: notification,
                        timeFormatter: timeFormatter,
                        isRead: isRead,
                        onTap: () {
                          setState(() {
                            notification['isRead'] = true;
                          });

                          final action = notification['actionUrl'] as String?;

                          if (action != null && action.isNotEmpty) {
                            // navigate using GoRouter
                            context.push(action);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No action for this notification'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        onDismiss: () {
                          setState(() {
                            filteredNotifications.removeAt(index);
                            notifications.removeWhere((n) => n['id'] == notification['id']);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      backgroundColor: Colors.grey[100],
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final DateFormat timeFormatter;
  final bool isRead;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.timeFormatter,
    required this.isRead,
    required this.onTap,
    required this.onDismiss,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'appointment':
        return Icons.calendar_today;
      case 'lab':
        return Icons.science;
      case 'prescription':
        return Icons.medication;
      case 'alert':
        return Icons.warning;
      case 'health_tip':
        return Icons.favorite;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type, BuildContext context) {
    switch (type) {
      case 'appointment':
        return Theme.of(context).colorScheme.primary;
      case 'lab':
        return Colors.purple;
      case 'prescription':
        return Colors.green;
      case 'alert':
        return Colors.red;
      case 'health_tip':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = notification['type'] as String;
    final color = _getColorForType(type, context);
    final timestamp = notification['timestamp'] as DateTime;

    return Dismissible(
      key: Key(notification['id']),
      onDismissed: (_) => onDismiss(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: isRead ? Theme.of(context).cardColor : Theme.of(context).colorScheme.primary.withOpacity(0.06),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(_getIconForType(type), color: color),
            ),
          ),
          title: Text(
            notification['title'] as String,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            notification['message'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeFormatter.format(timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              if (!isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          onTap: onTap,
          isThreeLine: true,
        ),
      ),
    );
  }
}