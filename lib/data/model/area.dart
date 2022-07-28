import 'dart:ui';

class Area {
  final List<Offset> points;
  final int color;
  final Offset location;
  final String description;

  Area(
      {required this.points,
      required this.color,
      required this.location,
      required this.description});

  factory Area.fromJson(Map<String, dynamic> json) => Area(
      points: json['points'],
      color: json['color'],
      location: json['location'],
      description: json['description']);
}
