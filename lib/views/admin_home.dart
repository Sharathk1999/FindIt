import 'package:findit_admin_app/containers/dashboard_text.dart';
import 'package:findit_admin_app/containers/home_btn.dart';
import 'package:findit_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().logOut();
              ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                                content: Text(
                                  "Logout Successful",
                                ),
                              ),
                            );
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 240,
              padding:const EdgeInsets.all(12),
              margin:const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.withAlpha(40),
                  borderRadius: BorderRadius.circular(10)),
              child:const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardText(keyword: "Total Orders", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                  DashboardText(keyword: "Total Products", value: "120"),
                ],
              ),
            ),
            Row(
              children: [
                HomeBtn(
                  onTap: () {},
                  name: "Orders",
                ),
                HomeBtn(
                  onTap: () {
                    Navigator.pushNamed(context, "/product");
                  },
                  name: "Products",
                ),
              ],
            ),
            Row(
              children: [
                HomeBtn(
                  onTap: () {},
                  name: "Promos",
                ),
                HomeBtn(
                  onTap: () {},
                  name: "Banners",
                ),
              ],
            ),
            Row(
              children: [
                HomeBtn(
                  onTap: () {
                    Navigator.pushNamed(context, "/category");
                  },
                  name: "Categories",
                ),
                HomeBtn(
                  onTap: () {},
                  name: "Coupons",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
