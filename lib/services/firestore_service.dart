import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserData(User user) async {
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'createdAt': Timestamp.now(),
    };

    await _db.collection('users').doc(user.uid).set(userData);
  }

  Future<void> bookAppointment(String userId, String doctorId, DateTime dateTime) async {
    Map<String, dynamic> appointmentData = {
      'userId': userId,
      'doctorId': doctorId,
      'dateTime': dateTime,
      'status': 'Pending',
      'createdAt': Timestamp.now(),
    };

    await _db.collection('appointments').add(appointmentData);
  }

  Stream<List<Appointment>> getUserAppointments(String userId) {
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList());
  }
}

class Appointment {
  final String userId;
  final String doctorId;
  final DateTime dateTime;
  final String status;
  final Timestamp createdAt;

  Appointment({required this.userId, required this.doctorId, required this.dateTime, required this.status, required this.createdAt});

  factory Appointment.fromMap(Map<String, dynamic> data) {
    return Appointment(
      userId: data['userId'],
      doctorId: data['doctorId'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }
}
