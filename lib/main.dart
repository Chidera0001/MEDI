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
  // Ensure all Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only if it's not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Lock screen orientation to portrait mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // Run the main application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyApp({super.key});

  // Determines the initial route based on user authentication state
  Future<Widget> _getInitialRoute() async {
    User? user = _auth.currentUser;
    
    // Show Splash Screen if user is not authenticated, otherwise go to MainPage
    if (user == null) {
      return const SplashScreen();
    } else {
      return const MainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialRoute(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        // Display loading indicator while waiting for authentication state check
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        // If there is an error, show a fallback error screen (optional)
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        // Return the authenticated or non-authenticated starting page
        return MaterialApp(
          home: snapshot.data ?? const SplashScreen(), // Default to SplashScreen if snapshot data is null
          routes: {
            '/login': (context) => const FireBaseAuth(),
            '/home': (context) => const MainPage(),
            '/profile': (context) => const UserProfile(key: ValueKey('UserProfile')), // Provide a key
            '/MyAppointments': (context) => const MyAppointments(),
            '/DoctorProfile': (context) => const DoctorProfile(
              key: ValueKey('DoctorProfile'), 
              doctor: 'Doctor Name', // Example doctor name
            ),
          },
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
