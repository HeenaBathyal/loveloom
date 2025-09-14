import 'package:flutter/material.dart';
import 'register.dart';
import 'dashboard.dart';
import 'login.dart';
import 'editprofile.dart';
import 'note.dart';
import 'findthematch.dart'; // Include your findthematch page
import 'splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoveLoom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Nunito',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/note': (context) => const NotePage(),
        '/findthematch': (context) => const FindTheMatchPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/editprofile') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (context) => EditProfilePage(
              name: args['name'] as String? ?? '',
              initialDob: args['dob'] as String? ?? '',
              initialImage: args['image'] as String?,
              initialLocation: args['location'] as String?,
              initialGalleryImages:
                  (args['galleryImages'] as List<dynamic>?)?.cast<String>() ?? [],
              initialNotes:
                  (args['notes'] as List<dynamic>?)?.cast<String>() ?? [],
            ),
          );
        }
        return null;
      },
    );
  }
}
