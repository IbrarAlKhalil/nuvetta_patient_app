class RecordModel {
  final String id;
  final String title;
  final String type;
  final String description;
  final DateTime date;
  final String? attachmentUrl;
  final String? attachmentName;

  RecordModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.date,
    this.attachmentUrl,
    this.attachmentName,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.now();
    final rawDate = json['date'] ?? json['recordDate'] ?? json['uploadedAt'] ?? json['createdAt'];
    if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? date;
    } else if (rawDate is int) {
      date = DateTime.fromMillisecondsSinceEpoch(rawDate);
    }

    final attachmentName = json['attachmentName']?.toString() ?? json['fileName']?.toString();
    final rawType = json['type']?.toString() ?? json['mimeType']?.toString();
    final inferredType = rawType?.split('/').last.toUpperCase() ??
        (attachmentName != null && attachmentName.contains('.')
            ? attachmentName.split('.').last.toUpperCase()
            : null);

    return RecordModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? attachmentName ?? 'Medical Record',
      type: json['type']?.toString() ?? inferredType ?? 'Unknown',
      description: json['description']?.toString() ?? json['mimeType']?.toString() ?? '',
      date: date,
      attachmentUrl: json['attachmentUrl']?.toString() ?? json['fileUrl']?.toString() ?? json['documentUrl']?.toString() ?? json['filePath']?.toString(),
      attachmentName: attachmentName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
