import 'package:findit_admin_app/firebase_options.dart';
import 'package:findit_admin_app/views/login_page.dart';
import 'package:findit_admin_app/views/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routes: {
        "/":(context)=> const LoginPage(),
        "/login":(context)=> const LoginPage(),
        "/signUp":(context)=> const SignUpPage(),
      },
    );
  }
}

