import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String userId;
  final String doctorId;
  final DateTime dateTime;
  final String status;

  Appointment({
    required this.userId,
    required this.doctorId,
    required this.dateTime,
    required this.status,
  });

  factory Appointment.fromMap(Map<String, dynamic> data) {
    return Appointment(
      userId: data['userId'],
      doctorId: data['doctorId'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      status: data['status'],
    );
  }
}
