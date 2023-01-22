import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock/consts/cores.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDZMwqJM3Kt7IDJVk6EcqcNgNwK33Xm0oI",
        authDomain: "e-commerce-3d0de.firebaseapp.com",
        projectId: "e-commerce-3d0de",
        storageBucket: "e-commerce-3d0de.appspot.com",
        messagingSenderId: "511028445406",
        appId: "1:511028445406:web:281a9578c2fe74014c024f",
        measurementId: "G-SSTY29PHGR"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metraço | Login',
      theme: ThemeData(
        primarySwatch: blue,
        appBarTheme: const AppBarTheme(color: lightYellow),
        scaffoldBackgroundColor: blue,
      ),
      home: const LoginScreen(),
    );
  }
}

/* class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: LoginScreen(),
    );
  }

  Container buildPage(Color color, String text) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 50.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} */
