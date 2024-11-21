import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medi_quick/screens/doctorProfile.dart';
import 'package:medi_quick/screens/firebaseAuth.dart';
import 'package:medi_quick/mainPage.dart';
import 'package:medi_quick/screens/myAppointments.dart';
import 'package:medi_quick/screens/splashScreen.dart';
import 'package:medi_quick/screens/userProfile.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      Firebase.app(); // Get existing app instance
    } else {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Set orientation preferences
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyApp({super.key});

  Future<Widget> _getInitialRoute() async {
    try {
      User? user = _auth.currentUser;
      return user == null ? const SplashScreen() : const MainPage();
    } catch (e) {
      print('Error checking user auth state: $e');
      return const SplashScreen(); // Fallback to splash screen on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialRoute(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen instead of just a CircularProgressIndicator
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }
        
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing app: ${snapshot.error}'),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        return MaterialApp(
          home: snapshot.data,
          routes: {
            '/login': (context) => const FireBaseAuth(),
            '/home': (context) => const MainPage(),
            '/profile': (context) => const UserProfile(
              key: ValueKey('UserProfile'),
            ),
            '/MyAppointments': (context) => const MyAppointments(),
            '/DoctorProfile': (context) => const DoctorProfile(
              key: ValueKey('DoctorProfile'),
              doctor: 'Doctor Name',
            ),
          },
          theme: ThemeData(brightness: Brightness.light),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}