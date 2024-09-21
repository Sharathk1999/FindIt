// ignore_for_file: use_build_context_synchronously

import 'package:findit_admin_app/containers/dashboard_text.dart';
import 'package:findit_admin_app/containers/home_btn.dart';
import 'package:findit_admin_app/controllers/auth_service.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            onPressed: () async{
            await  AuthService().logOut();
            Provider.of<AdminProvider>(context, listen: false).cancelProviders();
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
        child: Consumer<AdminProvider>(
          builder: (context, value, child) =>Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .4,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withAlpha(40),
                    borderRadius: BorderRadius.circular(10)),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashboardText(keyword: "Total Orders", value: "${value.totalOrders}"),
                    DashboardText(keyword: "Total Products", value: "${value.products.length}"),
                    DashboardText(keyword: "Total Categories", value: "${value.categories.length}"),
                    DashboardText(keyword: "Orders Waiting for Shipping", value: "${value.categories.length}"),
                    DashboardText(keyword: "Orders Shipped", value: "${value.ordersOnTheWay}"),
                    DashboardText(keyword: "Orders Delivered", value: "${value.ordersDelivered}"),
                    DashboardText(keyword: "Orders Cancelled", value: "${value.ordersCancelled}"),
                  ],
                ),
              ),
             
              Row(
                children: [
                  HomeBtn(
                    onTap: () {
                        Navigator.pushNamed(context, "/orders");
                    },
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
                    onTap: () {
                      Navigator.pushNamed(context, "/promos",
                          arguments: {"promo": true});
                    },
                    name: "Promos",
                  ),
                  HomeBtn(
                    onTap: () {
                      Navigator.pushNamed(context, "/promos",
                          arguments: {"promo": false});
                    },
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
                    onTap: () {
                      Navigator.pushNamed(context, "/coupons");
                    },
                    name: "Coupons",
                  ),
                ],
              ),
               //Pie chart
              Container(
                padding: const EdgeInsets.all(10),
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: showingSections(value),
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  List<PieChartSectionData> showingSections(AdminProvider value) {
    return List.generate(6, (i) {
       const fontSize = 12.0;
      const radius = 60.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: value.totalOrders.toDouble(),
            title: 'Orders',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: value.products.length.toDouble(),
            title: 'Products',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orange,
            value: value.categories.length.toDouble(),
            title: 'Categories',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: value.ordersPendingProcess.toDouble(),
            title: 'Waiting',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.purple,
            value: value.ordersOnTheWay.toDouble(),
            title: 'Shipped',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: Colors.yellow,
            value: value.ordersDelivered.toDouble(),
            title: 'Delivered',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          return PieChartSectionData();
      }
    });
  }

