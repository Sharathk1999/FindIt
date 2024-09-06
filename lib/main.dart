import 'package:findit_admin_app/controllers/auth_service.dart';
import 'package:findit_admin_app/firebase_options.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:findit_admin_app/views/admin_home.dart';
import 'package:findit_admin_app/views/category_page.dart';
import 'package:findit_admin_app/views/login_page.dart';
import 'package:findit_admin_app/views/modify_product_page.dart';
import 'package:findit_admin_app/views/products_page.dart';
import 'package:findit_admin_app/views/sign_up_page.dart';
import 'package:findit_admin_app/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
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
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FindIt Admin App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => const CheckUserLoggedIn(),
          "/home": (context) => const AdminHome(),
          "/login": (context) => const LoginPage(),
          "/signUp": (context) => const SignUpPage(),
          "/category": (context) => const CategoryPage(),
          "/product": (context) => const ProductsPage(),
          "/add_product": (context) => const ModifyProductPage(),
          "/view_product": (context) => const ViewProduct(),
          

        },
      ),
    );
  }
}

class CheckUserLoggedIn extends StatefulWidget {
  const CheckUserLoggedIn({super.key});

  @override
  State<CheckUserLoggedIn> createState() => _CheckUserLoggedInState();
}

class _CheckUserLoggedInState extends State<CheckUserLoggedIn> {
  @override
  void initState() {
    super.initState();
    AuthService().isLoggedIn().then(
      (value) {
        if (value) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
