import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Notes {
  final String uuid;
  final String? title;
  final String? details;
  final List<String>? label;

  Notes({
    required this.title,
    required this.details,
    required this.label,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Notes updated([String? title, String? details, List<String>? label]) => Notes(
        title: title ?? this.title,
        details: details ?? this.details,
        label: label ?? this.label,
        uuid: uuid,
      );

  @override
  bool operator ==(covariant Notes other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Notes(title: $title, details:$details, label:$label, uuid:$uuid)';
  }
}
